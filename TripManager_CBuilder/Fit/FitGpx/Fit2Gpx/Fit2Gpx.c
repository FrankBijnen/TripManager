// Based on the sample decode
// This program reads a fit file, and writes a track gpx to stdout
// Returns 0 on succes

#define _CRT_SECURE_NO_WARNINGS
#undef VERBOSE // Print verbose. GPX will be invalid
#include <time.h>
#include "stdio.h"
#include "string.h"
#include <math.h>
#include "fit_convert.h"

int main(int argc, char* argv[])
{
   FILE *file;
   FIT_UINT8 buf[8];
   FIT_CONVERT_RETURN convert_return = FIT_CONVERT_CONTINUE;
   FIT_UINT32 buf_size;
   FIT_UINT32 mesg_index = 0;

   if (argc < 2)
   {
      printf("usage: Fit2Gpx.exe <fit file>");
      return FIT_FALSE;
   }

   #if defined(VERBOSE)
      printf("Testing file conversion using %s file...\n", argv[1]);
   #endif

   FitConvert_Init(FIT_TRUE);

   if((file = fopen(argv[1], "rb")) == NULL)
   {
      printf("Error opening file %s.\n", argv[1]);
      return FIT_FALSE;
   }

   while(!feof(file) && (convert_return == FIT_CONVERT_CONTINUE))
   {
      for(buf_size=0;(buf_size < sizeof(buf)) && !feof(file); buf_size++)
      {
         buf[buf_size] = (FIT_UINT8)getc(file);
      }

      do
      {
         convert_return = FitConvert_Read(buf, buf_size);

         switch (convert_return)
         {
            case FIT_CONVERT_MESSAGE_AVAILABLE:
            {
               const FIT_UINT8 *mesg = FitConvert_GetMessageData();
               FIT_UINT16 mesg_num = FitConvert_GetMessageNumber();
               #if defined(VERBOSE)
                  printf("Mesg %d (%d) - ", mesg_index++, mesg_num);
               #endif
               switch(mesg_num)
               {
                  case FIT_MESG_NUM_FILE_ID:
                  {
                     #if defined(VERBOSE)
                        const FIT_FILE_ID_MESG *id = (FIT_FILE_ID_MESG *) mesg;
                        printf("File ID: type=%u, number=%u\n", id->type, id->number);
                     #endif
                     break;
                  }

                  case FIT_MESG_NUM_COURSE:
                  {
                      const FIT_COURSE_MESG *id = (FIT_COURSE_MESG *)mesg;
                      printf("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n");
                      printf("<gpx xmlns=\"http://www.topografix.com/GPX/1/1\" ");
                      printf("xmlns:gpxx=\"http://www.garmin.com/xmlschemas/GpxExtensions/v3\" ");
                      printf("xmlns:wptx1=\"http://www.garmin.com/xmlschemas/WaypointExtension/v1\" ");
                      printf("xmlns:ctx=\"http://www.garmin.com/xmlschemas/CreationTimeExtension/v1\" creator=\"TDBWare\" version=\"1.1\">\n");
                      printf("<trk><name>%s</name><trkseg>\n", id->name);
                      #if defined(VERBOSE)
                          printf("Course: %s\n", id->name);
                      #endif
                      break;
                  }

                  case FIT_MESG_NUM_USER_PROFILE:
                  {
                     #if defined(VERBOSE)
                        const FIT_USER_PROFILE_MESG *user_profile = (FIT_USER_PROFILE_MESG *) mesg;
                        printf("User Profile: weight=%0.1fkg\n", user_profile->weight / 10.0f);
                     #endif
                     break;
                  }

                  case FIT_MESG_NUM_ACTIVITY:
                  {
                     #if defined(VERBOSE)
                         const FIT_ACTIVITY_MESG *activity = (FIT_ACTIVITY_MESG *) mesg;
                         printf("Activity: timestamp=%u, type=%u, event=%u, event_type=%u, num_sessions=%u\n", activity->timestamp, activity->type, activity->event, activity->event_type, activity->num_sessions);
                         {
                            FIT_ACTIVITY_MESG old_mesg;
                            old_mesg.num_sessions = 1;
                            FitConvert_RestoreFields(&old_mesg);
                            printf("Restored num_sessions=1 - Activity: timestamp=%u, type=%u, event=%u, event_type=%u, num_sessions=%u\n", activity->timestamp, activity->type, activity->event, activity->event_type, activity->num_sessions);
                         }
                     #endif
                     break;
                  }

                  case FIT_MESG_NUM_SESSION:
                  {
                     #if defined(VERBOSE)
                        const FIT_SESSION_MESG *session = (FIT_SESSION_MESG *) mesg;
                        printf("Session: timestamp=%u\n", session->timestamp);
                     #endif
                     break;
                  }

                  case FIT_MESG_NUM_LAP:
                  {
                     #if defined(VERBOSE)
                        const FIT_LAP_MESG *lap = (FIT_LAP_MESG *) mesg;
                        printf("Lap: timestamp=%u\n", lap->timestamp);
                     #endif
                     break;
                  }

                  case FIT_MESG_NUM_RECORD:
                  {
                     const FIT_RECORD_MESG *record = (FIT_RECORD_MESG *) mesg;
                     // coordinates
                     const double todegrees = (180 / pow(2, 31));
                     double lat = (record->position_lat) ? record->position_lat * todegrees : 0;
                     double lon = (record->position_long) ? record->position_long * todegrees : 0;
                     // timestamp
                     time_t tms = record->timestamp + 631065600; // Seconds since 1989 something
                     struct tm ts = *gmtime(&tms);
                     char   buf[80];
                     // Elevation
                     double alt = (record->altitude) ? (double)(record->altitude / 5.0) - 500.0: 0;
                     strftime(buf, sizeof(buf), "%Y-%m-%dT%H:%M:%SZ", &ts);
                     // Write to GPX
                     printf("<trkpt lat=\"%.6f\" lon=\"%.6f\">", lat, lon);
                     printf("<ele>%.1f</ele>", alt);
                     printf("<time>%s</time></trkpt>", buf);
                     #if defined(VERBOSE)
                         printf("Record: timestamp=%s lat: %f lon: %f", buf, lat, lon);
                         if (
                               (record->compressed_speed_distance[0] != FIT_BYTE_INVALID) ||
                               (record->compressed_speed_distance[1] != FIT_BYTE_INVALID) ||
                               (record->compressed_speed_distance[2] != FIT_BYTE_INVALID)
                            )
                         {
                            static FIT_UINT32 accumulated_distance16 = 0;
                            static FIT_UINT32 last_distance16 = 0;
                            FIT_UINT16 speed100;
                            FIT_UINT32 distance16;

                            speed100 = record->compressed_speed_distance[0] | ((record->compressed_speed_distance[1] & 0x0F) << 8);
                            printf(", speed = %0.2fm/s", speed100/100.0f);

                            distance16 = (record->compressed_speed_distance[1] >> 4) | (record->compressed_speed_distance[2] << 4);
                            accumulated_distance16 += (distance16 - last_distance16) & 0x0FFF;
                            last_distance16 = distance16;

                            printf(", distance = %0.3fm", accumulated_distance16/16.0f);
                         }
                     #endif
                     printf("\n");
                     break;
                  }

                  case FIT_MESG_NUM_EVENT:
                  {
                     #if defined(VERBOSE)
                        const FIT_EVENT_MESG *event = (FIT_EVENT_MESG *) mesg;
                        printf("Event: timestamp=%u\n", event->timestamp);
                     #endif
                     break;
                  }

                  case FIT_MESG_NUM_DEVICE_INFO:
                  {
                     #if defined(VERBOSE)
                        const FIT_DEVICE_INFO_MESG *device_info = (FIT_DEVICE_INFO_MESG *) mesg;
                        printf("Device Info: timestamp=%u\n", device_info->timestamp);
                     #endif
                     break;
                  }

                  default:
                     #if defined(VERBOSE)
                        printf("Unknown\n");
                     #endif
                     break;
               }
               break;
            }

            default:
               break;
         }
      } while (convert_return == FIT_CONVERT_MESSAGE_AVAILABLE);
   }

   if (convert_return == FIT_CONVERT_ERROR)
   {
      printf("Error decoding file.\n");
      fclose(file);
      return 1;
   }

   if (convert_return == FIT_CONVERT_CONTINUE)
   {
      printf("Unexpected end of file.\n");
      fclose(file);
      return 1;
   }

   if (convert_return == FIT_CONVERT_DATA_TYPE_NOT_SUPPORTED)
   {
      printf("File is not FIT.\n");
      fclose(file);
      return 1;
   }

   if (convert_return == FIT_CONVERT_PROTOCOL_VERSION_NOT_SUPPORTED)
   {
      printf("Protocol version not supported.\n");
      fclose(file);
      return 1;
   }

   if (convert_return == FIT_CONVERT_END_OF_FILE)
   {
      printf("</trkseg></trk></gpx>\n");
   #if defined(VERBOSE)
      printf("File converted successfully.\n");
   #endif
   }
   fclose(file);

   return 0;
}
