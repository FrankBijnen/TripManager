// Based on the sample decode
// This program reads a fit file, and writes (session) info to stdout
// Returns 0 on succes

#define _CRT_SECURE_NO_WARNINGS
#include <time.h>
#include "stdio.h"
#include "string.h"
#include <math.h>
#include "fit_convert.h"

void TimeStamp2Buf(FIT_DATE_TIME timestamp, char *buf, int buflen) {
   time_t tms = timestamp + 631065600; // Seconds since 1989 something
   struct tm ts = *gmtime(&tms);
   strftime(buf, buflen, "%Y-%m-%d %H:%M:%S", &ts);
}

int main(int argc, char* argv[])
{
   FILE *file;
   FIT_UINT8 buf[8];
   FIT_CONVERT_RETURN convert_return = FIT_CONVERT_CONTINUE;
   FIT_UINT32 buf_size;
   FIT_UINT32 mesg_index = 0;
   FIT_FILE file_type = FIT_FILE_ACTIVITY;
   char DateTimeBuf[20];
   const double todegrees = (180 / pow(2, 31));


   if (argc < 2)
   {
      printf("usage: FitInfo.exe <fit file>");
      return FIT_FALSE;
   }

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
               switch(mesg_num)
               {
                  case FIT_MESG_NUM_FILE_ID:
                  {
                     const FIT_FILE_ID_MESG *id = (FIT_FILE_ID_MESG *) mesg;
                     file_type = id->type;
                     break;
                  }

                  case FIT_MESG_NUM_COURSE:
                  {
                      const FIT_COURSE_MESG *id = (FIT_COURSE_MESG *)mesg;
                      printf("Course=%s\n", id->name);
                      break;
                  }

                  case FIT_MESG_NUM_TRAINING_FILE:
                  {
                      const FIT_TRAINING_FILE_MESG *training = (FIT_TRAINING_FILE_MESG *)mesg;
                      TimeStamp2Buf(training->timestamp, DateTimeBuf, sizeof(DateTimeBuf));
                      printf("Started=%s\n", DateTimeBuf);
                      break;
                  }

                  case FIT_MESG_NUM_LAP:
                  {
                  	  const  FIT_LAP_MESG *lap = ( FIT_LAP_MESG *) mesg;

                      printf("*** Lap=%u\n", lap->message_index);

                      TimeStamp2Buf(lap->start_time, DateTimeBuf, sizeof(DateTimeBuf));
                      printf("Lap Started=%s\n", DateTimeBuf);
                      TimeStamp2Buf(lap->timestamp, DateTimeBuf, sizeof(DateTimeBuf));
                      printf("Lap Ended=%s\n", DateTimeBuf);

                      int min = lap->total_elapsed_time / 1000 / 60;
                      printf("Total Elapsed Time=%u H. %u Min.\n", (min / 60), (min % 60));
                      min = lap->total_timer_time / 1000 / 60;
                      printf("Total Timer Time=%u H. %u Min.\n", (min / 60), (min % 60));

                      printf("Total Distance=%.3f Km.\n", (double)lap->total_distance / 100 / 1000);

                      printf("Start Lat=%.6f\n", (lap->start_position_lat) ? lap->start_position_lat * todegrees : 0);
                      printf("Start Lon=%.6f\n", (lap->start_position_long) ? lap->start_position_long * todegrees : 0);
                      printf("End Lat=%.6f\n", (lap->end_position_lat) ? lap->end_position_lat * todegrees : 0);
                      printf("End Lon=%.6f\n", (lap->end_position_long) ? lap->end_position_long * todegrees : 0);

                      printf("Total Calories=%u\n", lap->total_calories);
                      printf("Avg Speed=%.2f\n", (double)lap->avg_speed * 3600 / 1000 /1000);
                      printf("Max Speed=%.2f\n", (double)lap->max_speed * 3600 / 1000 /1000);
                      printf("Total Ascent=%u Mtr.\n", lap->total_ascent);
                      printf("Total Descent=%u Mtr.\n", lap->total_descent);
                      break;
                  }

                  case FIT_MESG_NUM_SESSION:
                  {
                  	  const FIT_SESSION_MESG *session = (FIT_SESSION_MESG *) mesg;

                      printf("*** Session=%u\n", session->message_index);
                      printf("Profile=%s\n", session->sport_profile_name);

                      TimeStamp2Buf(session->start_time, DateTimeBuf, sizeof(DateTimeBuf));
                      printf("Started=%s\n", DateTimeBuf);
                      TimeStamp2Buf(session->timestamp, DateTimeBuf, sizeof(DateTimeBuf));
                      printf("Ended=%s\n", DateTimeBuf);

                      int min = session->total_elapsed_time / 1000 / 60;
                      printf("Total Elapsed Time=%u H. %u Min.\n", (min / 60), (min % 60));
                      min = session->total_timer_time / 1000 / 60;
                      printf("Total Timer Time=%u H. %u Min.\n", (min / 60), (min % 60));

                      printf("Total Distance=%.3f Km.\n", (double)session->total_distance / 100 / 1000);

                      printf("Start Lat=%.6f\n", (session->start_position_lat) ? session->start_position_lat * todegrees : 0);
                      printf("Start Lon=%.6f\n", (session->start_position_long) ? session->start_position_long * todegrees : 0);
                      printf("End Lat=%.6f\n", (session->end_position_lat) ? session->end_position_lat * todegrees : 0);
                      printf("End Lon=%.6f\n", (session->end_position_long) ? session->end_position_long * todegrees : 0);

                      printf("Total Calories=%u\n", session->total_calories);
                      printf("Avg Speed=%.2f\n", (double)session->avg_speed * 3600 / 1000 /1000);
                      printf("Max Speed=%.2f\n", (double)session->max_speed * 3600 / 1000 /1000);
                      printf("Total Ascent=%u Mtr.\n", session->total_ascent);
                      printf("Total Descent=%u Mtr.\n", session->total_descent);
                      break;
                  }

                  default:
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
   }

   fclose(file);

   return 0;
}
