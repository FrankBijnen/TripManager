// Based on the sample decode
// This program reads a fit file, and writes a track gpx to stdout
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
   strftime(buf, buflen, "%Y-%m-%dT%H:%M:%SZ", &ts);
}

int main(int argc, char* argv[])
{
  FILE *file;
  FIT_UINT8 buf[8];
  FIT_CONVERT_RETURN convert_return = FIT_CONVERT_CONTINUE;
  FIT_UINT32 buf_size;
  FIT_UINT32 mesg_index = 0;
  char DateTimeBuf[21];
  char CourseName[FIT_COURSE_MESG_NAME_COUNT] = "";
  FIT_FILE file_type = FIT_FILE_ACTIVITY;
  int HeaderDone = 0;

  if (argc < 2)
  {
    printf("usage: Fit2Gpx.exe <fit file>");
    return FIT_FALSE;
  }

  FitConvert_Init(FIT_TRUE);

  if((file = fopen(argv[1], "rb")) == NULL)
  {
    printf("Error opening file %s.\n", argv[1]);
    return FIT_FALSE;
  }

  while(!feof(file) &&
      (convert_return == FIT_CONVERT_CONTINUE))
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
              const FIT_FILE_ID_MESG *id = (FIT_FILE_ID_MESG *)mesg;
              file_type = id->type;
              break;
            }

            case FIT_MESG_NUM_COURSE:
            {
              const FIT_COURSE_MESG *course = (FIT_COURSE_MESG *)mesg;
              snprintf(CourseName, sizeof(CourseName), "%s", course->name);
              break;
            }

            case FIT_MESG_NUM_TRAINING_FILE:
            {
              const FIT_TRAINING_FILE_MESG *training = (FIT_TRAINING_FILE_MESG *)mesg;
              TimeStamp2Buf(training->timestamp, DateTimeBuf, sizeof(DateTimeBuf));
              snprintf(CourseName, sizeof(CourseName), "Activity %s", DateTimeBuf);
              break;
            }

            case FIT_MESG_NUM_RECORD:
            {
              const FIT_RECORD_MESG *record = (FIT_RECORD_MESG *) mesg;

              if (!HeaderDone)
              {
                printf("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n");
                printf("<gpx xmlns=\"http://www.topografix.com/GPX/1/1\" ");
                printf("xmlns:gpxx=\"http://www.garmin.com/xmlschemas/GpxExtensions/v3\" ");
                printf("xmlns:wptx1=\"http://www.garmin.com/xmlschemas/WaypointExtension/v1\" ");
                printf("xmlns:ctx=\"http://www.garmin.com/xmlschemas/CreationTimeExtension/v1\" creator=\"TDBWare\" version=\"1.1\">\n");
                printf("<trk><name>%s</name><trkseg>\n", CourseName);
                HeaderDone = 1;
              }

              // coordinates
              const double todegrees = (180 / pow(2, 31));
              double lat = (record->position_lat) ? record->position_lat * todegrees : 0;
              double lon = (record->position_long) ? record->position_long * todegrees : 0;
              // Check for valid coordinates
              if ((fabs(lat) > 90) ||
                 (fabs(lon) > 180))
              {
                break;
              }

              // timestamp
              TimeStamp2Buf(record->timestamp, DateTimeBuf, sizeof(DateTimeBuf));

              // Elevation
              double alt = (record->altitude) ? (double)(record->altitude / 5.0) - 500.0: 0;

              // Write to GPX
              printf("<trkpt lat=\"%.6f\" lon=\"%.6f\">", lat, lon);
              printf("<ele>%.1f</ele>", alt);
              printf("<time>%s</time></trkpt>", DateTimeBuf);
              printf("\n");
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
    printf("</trkseg></trk></gpx>\n");
  }
  fclose(file);

  return 0;
}
