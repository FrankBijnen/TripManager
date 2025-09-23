////////////////////////////////////////////////////////////////////////////////
// The following FIT Protocol software provided may be used with FIT protocol
// devices only and remains the copyrighted property of Dynastream Innovations Inc.
// The software is being provided on an "as-is" basis and as an accommodation,
// and therefore all warranties, representations, or guarantees of any kind
// (whether express, implied or statutory) including, without limitation,
// warranties of merchantability, non-infringement, or fitness for a particular
// purpose, are specifically disclaimed.
//
// Copyright 2008-2015 Dynastream Innovations Inc.
////////////////////////////////////////////////////////////////////////////////
#define _CRT_SECURE_NO_WARNINGS

#include "stdio.h"
#include "string.h"
#include <math.h>

#include "fit_product.h"
#include "fit_crc.h"

// 2 * PI (3.14159265)
#define TWOPI 6.2831853

// Number of semicircles per meter at the equator
#define SC_PER_M 107.173

///////////////////////////////////////////////////////////////////////
// Private Function Prototypes
///////////////////////////////////////////////////////////////////////

void WriteFileHeader(FILE *fp);
///////////////////////////////////////////////////////////////////////
// Creates a FIT file. Puts a place-holder for the file header on top of the file.
///////////////////////////////////////////////////////////////////////

void WriteMessageDefinition(FIT_UINT8 local_mesg_number, const void *mesg_def_pointer, FIT_UINT16 mesg_def_size, FILE *fp);
///////////////////////////////////////////////////////////////////////
// Appends a FIT message definition (including the definition header) to the end of a file.
///////////////////////////////////////////////////////////////////////

void WriteMessageDefinitionWithDevFields
(
    FIT_UINT8 local_mesg_number,
    const void *mesg_def_pointer,
    FIT_UINT8 mesg_def_size,
    FIT_UINT8 number_dev_fields,
    FIT_DEV_FIELD_DEF *dev_field_definitions,
    FILE *fp
);
///////////////////////////////////////////////////////////////////////
// Appends a FIT message definition (including the definition header)
// and additionalo dev field definition data to the end of a file.
///////////////////////////////////////////////////////////////////////

void WriteMessage(FIT_UINT8 local_mesg_number, const void *mesg_pointer, FIT_UINT16 mesg_size, FILE *fp);
///////////////////////////////////////////////////////////////////////
// Appends a FIT message (including the message header) to the end of a file.
///////////////////////////////////////////////////////////////////////

void WriteDeveloperField(const void* data, FIT_UINT16 data_size, FILE *fp);
///////////////////////////////////////////////////////////////////////
// Appends Developer Fields to a Message
///////////////////////////////////////////////////////////////////////

void WriteData(const void *data, FIT_UINT16 data_size, FILE *fp);
///////////////////////////////////////////////////////////////////////
// Writes data to the file and updates the data CRC.
///////////////////////////////////////////////////////////////////////

void ParseBuf(char *buf,
              FIT_DATE_TIME *otimestamp,
              FIT_UINT32 *olat,
              FIT_UINT32 *olon,
              FIT_UINT32 *odist,
              FIT_UINT16 *oele)
{
    int a, b, c, d, e;

    int res = sscanf(buf, "%d,%d,%d,%d,%d", &a, &b, &c, &d, &e);
    *otimestamp = a;
    *olat = b;
    *olon = c;
    *odist = d;
    *oele = e;
}

///////////////////////////////////////////////////////////////////////
// Private Variables
///////////////////////////////////////////////////////////////////////

static FIT_UINT16 data_crc;

int main(void)
{
    FILE *fp;
    char buf[255];
    char oname[FIT_COURSE_MESG_NAME_COUNT];
    char ofile[255];

    if (fgets(buf, sizeof(buf), stdin) == NULL)
    {
        return 1;
    }
    buf[strcspn(buf, "\n")] = 0;
    snprintf(oname, sizeof(oname), "%s", buf);
    snprintf(ofile, sizeof(ofile), "%s.fit", buf);

    data_crc = 0;
    if (fgets(buf, sizeof(buf), stdin) == NULL)
    {
        return 1;
    }

    fp = fopen(ofile, "w+b");

    WriteFileHeader(fp);

    FIT_DATE_TIME timestamp; // 2021-09-08T01:46:40-0600Z in seconds since the FIT Epoch of 1989-12-31T:00:00:00Z
    FIT_UINT32 lat1 = 0;
    FIT_UINT32 lon1 = 0;
    FIT_UINT32 dist1, totaldist = 0;
    FIT_UINT16 ele1 = 0;

    buf[strcspn(buf, "\n")] = 0;
    ParseBuf(buf, &timestamp, &lat1, &lon1, &dist1, &ele1);
    FIT_DATE_TIME start_time = timestamp;

    // Write file id message.
    {
        FIT_UINT8 local_mesg_number = 0;
        FIT_FILE_ID_MESG file_id_mesg;
        Fit_InitMesg(fit_mesg_defs[FIT_MESG_FILE_ID], &file_id_mesg);

        file_id_mesg.time_created = timestamp;
        file_id_mesg.type = FIT_FILE_COURSE;
        file_id_mesg.manufacturer = FIT_MANUFACTURER_DEVELOPMENT;
        WriteMessageDefinition(local_mesg_number, fit_mesg_defs[FIT_MESG_FILE_ID], FIT_FILE_ID_MESG_DEF_SIZE, fp);
        WriteMessage(local_mesg_number, &file_id_mesg, FIT_FILE_ID_MESG_SIZE, fp);
    }

    // Write Course message.
    {
        FIT_UINT8 local_mesg_number = 1;
        FIT_COURSE_MESG course_mesg;
        Fit_InitMesg(fit_mesg_defs[FIT_MESG_COURSE], &course_mesg);

        course_mesg.capabilities = FIT_COURSE_CAPABILITIES_NAVIGATION;
        snprintf(course_mesg.name, sizeof(course_mesg.name), "%s", oname);
        course_mesg.sport = FIT_SPORT_CYCLING;

        WriteMessageDefinition(local_mesg_number, fit_mesg_defs[FIT_MESG_COURSE], FIT_COURSE_MESG_DEF_SIZE, fp);
        WriteMessage(local_mesg_number, &course_mesg, FIT_COURSE_MESG_SIZE, fp);
    }

    // Write Event message - START Event
    {
        FIT_UINT8 local_mesg_number = 2;
        FIT_EVENT_MESG event_mesg;
        Fit_InitMesg(fit_mesg_defs[FIT_MESG_EVENT], &event_mesg);

        event_mesg.timestamp = timestamp;
        event_mesg.event = FIT_EVENT_TIMER;
        event_mesg.event_type = FIT_EVENT_TYPE_START;

        WriteMessageDefinition(local_mesg_number, fit_mesg_defs[FIT_MESG_EVENT], FIT_EVENT_MESG_DEF_SIZE, fp);
        WriteMessage(local_mesg_number, &event_mesg, FIT_EVENT_MESG_SIZE, fp);
    }

    // Write Record messages.

    //The message definition only needs to be written once.
    {
        FIT_UINT8 local_mesg_number = 3;
        WriteMessageDefinition(local_mesg_number, fit_mesg_defs[FIT_MESG_RECORD], FIT_RECORD_MESG_DEF_SIZE, fp);

        do
        {
            buf[strcspn(buf, "\n")] = 0;
            ParseBuf(buf, &timestamp, &lat1, &lon1, &dist1, &ele1);
            totaldist += dist1;

            FIT_RECORD_MESG record_mesg;
            Fit_InitMesg(fit_mesg_defs[FIT_MESG_RECORD], &record_mesg);
            // Only write these fields
            record_mesg.timestamp = timestamp;
            record_mesg.altitude = (ele1 + 500) * 5;
            record_mesg.position_lat = lat1;
            record_mesg.position_long = lon1;
            record_mesg.distance = totaldist;

            WriteMessage(local_mesg_number, &record_mesg, FIT_RECORD_MESG_SIZE, fp);
        } while (fgets(buf, sizeof(buf), stdin) != NULL);
    }

    // Write Event message - STOP Event
    {
        FIT_UINT8 local_mesg_number = 4;
        FIT_EVENT_MESG event_mesg;
        Fit_InitMesg(fit_mesg_defs[FIT_MESG_EVENT], &event_mesg);

        event_mesg.timestamp = timestamp;
        event_mesg.event = FIT_EVENT_TIMER;
        event_mesg.event_type = FIT_EVENT_TYPE_STOP;

        WriteMessageDefinition(local_mesg_number, fit_mesg_defs[FIT_MESG_EVENT], FIT_EVENT_MESG_DEF_SIZE, fp);
        WriteMessage(local_mesg_number, &event_mesg, FIT_EVENT_MESG_SIZE, fp);
    }

    // Write Lap message.
    {
        FIT_UINT8 local_mesg_number = 5;
        FIT_LAP_MESG lap_mesg;
        Fit_InitMesg(fit_mesg_defs[FIT_MESG_LAP], &lap_mesg);

        lap_mesg.message_index = 0;
        lap_mesg.timestamp = timestamp;
        lap_mesg.start_time = start_time;
        lap_mesg.total_elapsed_time = (timestamp - start_time) * 1000;
        lap_mesg.total_timer_time = (timestamp - start_time) * 1000;
        lap_mesg.total_distance = totaldist;
        WriteMessageDefinition(local_mesg_number, fit_mesg_defs[FIT_MESG_LAP], FIT_LAP_MESG_DEF_SIZE, fp);
        WriteMessage(local_mesg_number, &lap_mesg, FIT_LAP_MESG_SIZE, fp);
    }

    // Write Session message.
    {
        FIT_UINT8 local_mesg_number = 6;
        FIT_SESSION_MESG session_mesg;
        Fit_InitMesg(fit_mesg_defs[FIT_MESG_SESSION], &session_mesg);

        session_mesg.message_index = 0;
        session_mesg.timestamp = timestamp;
        session_mesg.start_time = start_time;
        session_mesg.total_elapsed_time = (timestamp - start_time) * 1000;
        session_mesg.total_timer_time = (timestamp - start_time) * 1000;
        session_mesg.total_distance = totaldist;
        session_mesg.sport = FIT_SPORT_STAND_UP_PADDLEBOARDING;
        session_mesg.sub_sport = FIT_SUB_SPORT_GENERIC;
        session_mesg.first_lap_index = 0;
        session_mesg.num_laps = 1;

        WriteMessageDefinition(local_mesg_number, fit_mesg_defs[FIT_MESG_SESSION], FIT_SESSION_MESG_DEF_SIZE, fp);
        WriteMessage(local_mesg_number, &session_mesg, FIT_SESSION_MESG_SIZE, fp);
    }

    // Write Activity message.
    {
        FIT_UINT8 local_mesg_number = 7;
        FIT_ACTIVITY_MESG activity_mesg;
        Fit_InitMesg(fit_mesg_defs[FIT_MESG_ACTIVITY], &activity_mesg);

        activity_mesg.timestamp = timestamp;
        activity_mesg.num_sessions = 1;
        activity_mesg.total_timer_time = (timestamp - start_time) * 1000;

        WriteMessageDefinition(local_mesg_number, fit_mesg_defs[FIT_MESG_ACTIVITY], FIT_ACTIVITY_MESG_DEF_SIZE, fp);
        WriteMessage(local_mesg_number, &activity_mesg, FIT_ACTIVITY_MESG_SIZE, fp);
    }

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


