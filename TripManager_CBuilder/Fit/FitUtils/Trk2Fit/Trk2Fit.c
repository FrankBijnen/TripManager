// Based on the sample encode
// This program reads stdin, and creates a course FIT file.
// 1st Record = Name of the course, and file. Escape filename for invalid chars like : > < |
// 2..N record timestamp,lat,lon,distance,elevation (All integers)
// Close with CTRL/Z = CHR(26)
// Returns 0 on succes
#define _CRT_SECURE_NO_WARNINGS

#include "stdio.h"
#include "string.h"
#include <math.h>

#include "fit_product.h"
#include "fit_crc.h"

void WriteFileHeader(FILE *fp);
void WriteMessageDefinition(FIT_UINT8 local_mesg_number, const void *mesg_def_pointer, FIT_UINT16 mesg_def_size, FILE *fp);
void WriteMessageDefinitionWithDevFields
(
    FIT_UINT8 local_mesg_number,
    const void *mesg_def_pointer,
    FIT_UINT8 mesg_def_size,
    FIT_UINT8 number_dev_fields,
    FIT_DEV_FIELD_DEF *dev_field_definitions,
    FILE *fp
);
void WriteMessage(FIT_UINT8 local_mesg_number, const void *mesg_pointer, FIT_UINT16 mesg_size, FILE *fp);
void WriteDeveloperField(const void* data, FIT_UINT16 data_size, FILE *fp);
void WriteData(const void *data, FIT_UINT16 data_size, FILE *fp);
void ParseBuf(char *buf,
              FIT_DATE_TIME *otimestamp,
              FIT_UINT32 *olat,
              FIT_UINT32 *olon,
              FIT_UINT32 *odist,
              FIT_UINT16 *oele);

void WriteFileId(FIT_DATE_TIME timestamp, FIT_UINT8 local_mesg_number);
void WriteCourse(char *CourseName, FIT_UINT8 local_mesg_number);
void WriteEvent(FIT_DATE_TIME timestamp, FIT_EVENT_TYPE event_type, FIT_UINT8 local_mesg_number);
void WriteRecord(FIT_DATE_TIME timestamp,
                 FIT_UINT32 lat,
                 FIT_UINT32 lon,
                 FIT_UINT32 dist,
                 FIT_UINT16 ele,
                 FIT_UINT8 local_mesg_number);
void WriteLap(FIT_DATE_TIME timestamp,
              FIT_UINT32 start_time, FIT_UINT32 totaldist, FIT_UINT32 latstart, FIT_UINT32 lonstart, FIT_UINT32 latend, FIT_UINT32 lonend,
              FIT_UINT8 local_mesg_number);
void WriteSession(FIT_DATE_TIME timestamp,
                  FIT_UINT32 start_time, FIT_UINT32 totaldist, FIT_UINT32 latstart, FIT_UINT32 lonstart, FIT_UINT32 latend, FIT_UINT32 lonend,
                  FIT_UINT8 local_mesg_number);
void WriteActivity(FIT_DATE_TIME timestamp, FIT_UINT32 start_time, FIT_UINT8 local_mesg_number);

static FIT_UINT16 data_crc;
static FILE *fp;       // File pointer

int main(void)
{
    char buf[255];  // Buffer for reading STDIN
	char CourseName[FIT_COURSE_MESG_NAME_COUNT]; 	// Course name
	char FitFile[FIT_COURSE_MESG_NAME_COUNT]; 		// Fit File

    // Parsed buffer
    FIT_DATE_TIME timestamp;
    FIT_UINT32 lat1 = 0;
    FIT_UINT32 lon1 = 0;
    FIT_UINT32 latstart = 0;
    FIT_UINT32 lonstart = 0;
    FIT_UINT32 latend = 0;
    FIT_UINT32 lonend = 0;
    FIT_UINT32 dist1, totaldist = 0;
    FIT_UINT16 ele1 = 0;
    FIT_UINT8 mesg_number = 0;

    if (fgets(buf, sizeof(buf), stdin) == NULL)
    {
        return 1;
    }
    buf[strcspn(buf, "\n")] = 0; // replace NL with null terminator
    snprintf(CourseName, sizeof(CourseName), "%s", buf);
    snprintf(FitFile, sizeof(FitFile), "%s.fit", buf);

    data_crc = 0;
    if (fgets(buf, sizeof(buf), stdin) == NULL)
    {
        return 1;
    }

    fp = fopen(FitFile, "w+b");
    if (fp == NULL) {
    	perror("Open file failed: ");
    	return 1;
	}

    WriteFileHeader(fp);

    buf[strcspn(buf, "\n")] = 0;
    ParseBuf(buf, &timestamp, &lat1, &lon1, &dist1, &ele1);
    FIT_DATE_TIME start_time = timestamp;
    latstart = lat1;
    lonstart = lon1;
    WriteFileId(timestamp, mesg_number++);

	WriteCourse(CourseName, mesg_number++);

    WriteEvent(timestamp, FIT_EVENT_TYPE_START, mesg_number++);

    WriteMessageDefinition(mesg_number, fit_mesg_defs[FIT_MESG_RECORD], FIT_RECORD_MESG_DEF_SIZE, fp);
    do
    {
        buf[strcspn(buf, "\n")] = 0;
        ParseBuf(buf, &timestamp, &lat1, &lon1, &dist1, &ele1);
        totaldist += dist1;
        WriteRecord(timestamp, lat1, lon1, totaldist, ele1, mesg_number);

    } while (fgets(buf, sizeof(buf), stdin) != NULL);
    mesg_number++;
    latend = lat1;
    lonend = lon1;

    WriteEvent(timestamp, FIT_EVENT_TYPE_STOP, mesg_number++);

    WriteLap(timestamp, start_time, totaldist, latstart, lonstart, latend, lonend, mesg_number++);

    WriteSession(timestamp, start_time, totaldist, latstart, lonstart, latend, lonend, mesg_number++);

    WriteActivity(timestamp, start_time, mesg_number++);

    // Write CRC.
    fwrite(&data_crc, 1, sizeof(FIT_UINT16), fp);

    // Update file header with data size.
    WriteFileHeader(fp);

    fclose(fp);

    return 0;
}

void WriteFileHeader(FILE *fp)
{
    FIT_FILE_HDR file_header;

    file_header.header_size = FIT_FILE_HDR_SIZE;
    file_header.profile_version = FIT_PROFILE_VERSION;
    file_header.protocol_version = FIT_PROTOCOL_VERSION_20;
    memcpy((FIT_UINT8 *)&file_header.data_type, ".FIT", 4);
    fseek(fp, 0, SEEK_END);
    file_header.data_size = ftell(fp) - FIT_FILE_HDR_SIZE - sizeof(FIT_UINT16);
    file_header.crc = FitCRC_Calc16(&file_header, FIT_STRUCT_OFFSET(crc, FIT_FILE_HDR));

    fseek(fp, 0, SEEK_SET);
    fwrite((void *)&file_header, 1, FIT_FILE_HDR_SIZE, fp);
}

void WriteMessageDefinition(FIT_UINT8 local_mesg_number, const void *mesg_def_pointer, FIT_UINT16 mesg_def_size, FILE *fp)
{
    FIT_UINT8 header = local_mesg_number | FIT_HDR_TYPE_DEF_BIT;
    WriteData(&header, FIT_HDR_SIZE, fp);
    WriteData(mesg_def_pointer, mesg_def_size, fp);
}

void WriteMessageDefinitionWithDevFields
(
    FIT_UINT8 local_mesg_number,
    const void *mesg_def_pointer,
    FIT_UINT8 mesg_def_size,
    FIT_UINT8 number_dev_fields,
    FIT_DEV_FIELD_DEF *dev_field_definitions,
    FILE *fp
)
{
    FIT_UINT16 i;
    FIT_UINT8 header = local_mesg_number | FIT_HDR_TYPE_DEF_BIT | FIT_HDR_DEV_DATA_BIT;
    WriteData(&header, FIT_HDR_SIZE, fp);
    WriteData(mesg_def_pointer, mesg_def_size, fp);

    WriteData(&number_dev_fields, sizeof(FIT_UINT8), fp);
    for (i = 0; i < number_dev_fields; i++)
    {
        WriteData(&dev_field_definitions[i], sizeof(FIT_DEV_FIELD_DEF), fp);
    }
}

void WriteMessage(FIT_UINT8 local_mesg_number, const void *mesg_pointer, FIT_UINT16 mesg_size, FILE *fp)
{
    WriteData(&local_mesg_number, FIT_HDR_SIZE, fp);
    WriteData(mesg_pointer, mesg_size, fp);
}

void WriteDeveloperField(const void *data, FIT_UINT16 data_size, FILE *fp)
{
    WriteData(data, data_size, fp);
}

void WriteData(const void *data, FIT_UINT16 data_size, FILE *fp)
{
    FIT_UINT16 offset;

    fwrite(data, 1, data_size, fp);

    for (offset = 0; offset < data_size; offset++)
        data_crc = FitCRC_Get16(data_crc, *((FIT_UINT8 *)data + offset));
}

void ParseBuf(char *buf,
              FIT_DATE_TIME *otimestamp,
              FIT_UINT32 *olat,
              FIT_UINT32 *olon,
              FIT_UINT32 *odist,
              FIT_UINT16 *oele)
{
    int a = 0, b = 0, c = 0, d = 0, e = 0;

    sscanf(buf, "%d,%d,%d,%d,%d", &a, &b, &c, &d, &e);
    *otimestamp = a;
    *olat = b;
    *olon = c;
    *odist = d;
    *oele = e;
}

// Write file id message.
void WriteFileId(FIT_DATE_TIME timestamp, FIT_UINT8 local_mesg_number)
{
    FIT_FILE_ID_MESG file_id_mesg;
    Fit_InitMesg(fit_mesg_defs[FIT_MESG_FILE_ID], &file_id_mesg);

    file_id_mesg.time_created = timestamp;
    file_id_mesg.type = FIT_FILE_COURSE;
    file_id_mesg.manufacturer = FIT_MANUFACTURER_DEVELOPMENT;
    WriteMessageDefinition(local_mesg_number, fit_mesg_defs[FIT_MESG_FILE_ID], FIT_FILE_ID_MESG_DEF_SIZE, fp);
    WriteMessage(local_mesg_number, &file_id_mesg, FIT_FILE_ID_MESG_SIZE, fp);
}

// Write Course message.
void WriteCourse(char *CourseName, FIT_UINT8 local_mesg_number)
{
    FIT_COURSE_MESG course_mesg;
    Fit_InitMesg(fit_mesg_defs[FIT_MESG_COURSE], &course_mesg);

    course_mesg.capabilities = FIT_COURSE_CAPABILITIES_NAVIGATION;
    snprintf(course_mesg.name, sizeof(course_mesg.name), "%s", CourseName);
    course_mesg.sport = FIT_SPORT_CYCLING;

    WriteMessageDefinition(local_mesg_number, fit_mesg_defs[FIT_MESG_COURSE], FIT_COURSE_MESG_DEF_SIZE, fp);
    WriteMessage(local_mesg_number, &course_mesg, FIT_COURSE_MESG_SIZE, fp);
}

// Write Event message - START or STOP Event
void WriteEvent(FIT_DATE_TIME timestamp, FIT_EVENT_TYPE event_type, FIT_UINT8 local_mesg_number)
{
    FIT_EVENT_MESG event_mesg;
    Fit_InitMesg(fit_mesg_defs[FIT_MESG_EVENT], &event_mesg);

    event_mesg.timestamp = timestamp;
    event_mesg.event = FIT_EVENT_TIMER;
    event_mesg.event_type = event_type;

    WriteMessageDefinition(local_mesg_number, fit_mesg_defs[FIT_MESG_EVENT], FIT_EVENT_MESG_DEF_SIZE, fp);
    WriteMessage(local_mesg_number, &event_mesg, FIT_EVENT_MESG_SIZE, fp);
}

// Write Record message
void WriteRecord(FIT_DATE_TIME timestamp,
                 FIT_UINT32 lat,
                 FIT_UINT32 lon,
                 FIT_UINT32 dist,
                 FIT_UINT16 ele,
                 FIT_UINT8 local_mesg_number)
{
    FIT_RECORD_MESG record_mesg;
    Fit_InitMesg(fit_mesg_defs[FIT_MESG_RECORD], &record_mesg);

    // Only write these fields
    record_mesg.timestamp = timestamp;
    record_mesg.altitude = (ele + 500) * 5;
    record_mesg.position_lat = lat;
    record_mesg.position_long = lon;
    record_mesg.distance = dist;

    WriteMessage(local_mesg_number, &record_mesg, FIT_RECORD_MESG_SIZE, fp);
}

// Write Lap message.
void WriteLap(FIT_DATE_TIME timestamp,
              FIT_UINT32 start_time, FIT_UINT32 totaldist, FIT_UINT32 latstart, FIT_UINT32 lonstart, FIT_UINT32 latend, FIT_UINT32 lonend,
              FIT_UINT8 local_mesg_number)
{
    FIT_LAP_MESG lap_mesg;
    Fit_InitMesg(fit_mesg_defs[FIT_MESG_LAP], &lap_mesg);

    lap_mesg.message_index = 0;
    lap_mesg.timestamp = timestamp;
    lap_mesg.start_time = start_time;
    lap_mesg.total_elapsed_time = (timestamp - start_time) * 1000;
    lap_mesg.total_timer_time = (timestamp - start_time) * 1000;
    lap_mesg.total_distance = totaldist;
    lap_mesg.start_position_lat = latstart;
    lap_mesg.start_position_long = lonstart;
    lap_mesg.end_position_lat = latend;
    lap_mesg.end_position_long = lonend;
    WriteMessageDefinition(local_mesg_number, fit_mesg_defs[FIT_MESG_LAP], FIT_LAP_MESG_DEF_SIZE, fp);
    WriteMessage(local_mesg_number, &lap_mesg, FIT_LAP_MESG_SIZE, fp);
}

// Write Session message.
void WriteSession(FIT_DATE_TIME timestamp,
                  FIT_UINT32 start_time, FIT_UINT32 totaldist, FIT_UINT32 latstart, FIT_UINT32 lonstart, FIT_UINT32 latend, FIT_UINT32 lonend,
			      FIT_UINT8 local_mesg_number)
{
    FIT_SESSION_MESG session_mesg;
    Fit_InitMesg(fit_mesg_defs[FIT_MESG_SESSION], &session_mesg);

    session_mesg.message_index = 0;
    session_mesg.timestamp = timestamp;
    session_mesg.start_time = start_time;
    session_mesg.total_elapsed_time = (timestamp - start_time) * 1000;
    session_mesg.total_timer_time = (timestamp - start_time) * 1000;
    session_mesg.total_distance = totaldist;
    session_mesg.start_position_lat = latstart;
    session_mesg.start_position_long = lonstart;
    session_mesg.end_position_lat = latend;
    session_mesg.end_position_long = lonend;
    session_mesg.sport = FIT_SPORT_CYCLING;
    session_mesg.sub_sport = FIT_SUB_SPORT_GENERIC;
    session_mesg.first_lap_index = 0;
    session_mesg.num_laps = 1;

    WriteMessageDefinition(local_mesg_number, fit_mesg_defs[FIT_MESG_SESSION], FIT_SESSION_MESG_DEF_SIZE, fp);
    WriteMessage(local_mesg_number, &session_mesg, FIT_SESSION_MESG_SIZE, fp);
}

// Write Activity message.
void WriteActivity(FIT_DATE_TIME timestamp, FIT_UINT32 start_time, FIT_UINT8 local_mesg_number)
{
    FIT_ACTIVITY_MESG activity_mesg;
    Fit_InitMesg(fit_mesg_defs[FIT_MESG_ACTIVITY], &activity_mesg);

    activity_mesg.timestamp = timestamp;
    activity_mesg.num_sessions = 1;
    activity_mesg.total_timer_time = (timestamp - start_time) * 1000;

    WriteMessageDefinition(local_mesg_number, fit_mesg_defs[FIT_MESG_ACTIVITY], FIT_ACTIVITY_MESG_DEF_SIZE, fp);
    WriteMessage(local_mesg_number, &activity_mesg, FIT_ACTIVITY_MESG_SIZE, fp);
}

