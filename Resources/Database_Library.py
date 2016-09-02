
import pyodbc

__author__ = 'ifayner'


def connect_to_database(str_sql, hostname, wfg_database):
    # *** function to connect to SQL Server database, return rows and close connection  ***
    conn = pyodbc.connect("DRIVER={SQL Server};SERVER=" + hostname + ";DATABASE=" + wfg_database + ";Trusted_Connection=True")
    cursor = conn.cursor()
    print str_sql
    cursor.execute(str_sql)
    rows = cursor.fetchall()
    conn.close()
    return rows


def convert_the_date(str_date):
    # *** use "strip" method for "Trim" function to eliminate leading and ending spaces ***
    str_date = str(str_date).strip()
    # *** use "in" method for "InStr" to find the char and "index" to find the position to eliminate time ***
    if " " in str_date:
        str_date = str_date[0:str_date.index(" ")]
    day = str_date[8:]
    if day[0] == "0":
        day = day[1:2]
    month = str_date[5:7]
    if month[0] == "0":
        month = month[1:2]
    year = str_date[:4]
    str_date = month + "-" + day + "-" + year
    return str_date


def count_total_notifications(hostname, wfg_database):
    result = ""

    str_sql = "SELECT Count(NotificationID) AS NotificationID FROM wfgLU_Notification"
    rows = connect_to_database(str_sql, hostname, wfg_database)
    if rows:
        for row in rows:
            result = row[0]
    return result


def find_lifeline_agent(life_line_id, notification_typeid, state_code, hostname, wfg_database):
    agent_code_no = ""
    agent_notification_id = 0
    date_due = "01/01/1900"
    date_due_full = "01/01/1900"
    state = state_code
    print "My life_line_id = " + str(life_line_id)
    # *** LIKE doesn't work in Python, so Texas with Licence# should not be accepted. See WFGLLNotifications table ***
    if state_code == "TX" and str(life_line_id)== "4":
        state = ""
    if life_line_id == "1" or life_line_id == "27":
        str_sql = "SELECT Top 1 a.AgentCodeNumber, ll.AgentNotificationID, ll.AgentID,  ll.NotificationID, \
            n.[Description], ll.NotificationSubType, ll.NotificationTypeID, ll.DateDue, ll.Modified, ll.URLEnable \
            FROM [WFGOnline].[dbo].[WFGLLNotifications] ll \
            INNER JOIN [WFGCompass].[dbo].[agAgent]a ON a.AgentID = ll.AgentID \
            INNER JOIN [WFGOnline].[dbo].[wfgLU_Notification] n ON ll.NotificationID= n.NotificationID \
            INNER JOIN [WFGWorkflow].[dbo].[Agent_EandO_Collections] wf ON a.AgentCodeNumber = wf.AgentID \
            INNER JOIN (SELECT DISTINCT AgentID from [WFGCompass].[dbo].[agAgentCycleType] \
            WHERE CycleTypeStatusID = 1 AND EndDate > GETDATE()) c ON a.AgentID = c.AgentID  \
            WHERE ll.NotificationID = %s AND ll.NotificationTypeID = %s \
            ORDER BY AgentNotificationID desc" % (life_line_id, notification_typeid)
    else:
        if len(state) == 0:
            str_sql = "SELECT Top 1 a.AgentCodeNumber, ll.AgentNotificationID, ll.AgentID,  ll.NotificationID, \
                n.[Description], ll.NotificationSubType, ll.NotificationTypeID, ll.DateDue, ll.Modified, ll.URLEnable \
                FROM [WFGOnline].[dbo].[WFGLLNotifications] ll \
                INNER JOIN [WFGCompass].[dbo].[agAgent]a ON a.AgentID = ll.AgentID \
                INNER JOIN [WFGOnline].[dbo].[wfgLU_Notification] n ON ll.NotificationID= n.NotificationID \
                INNER JOIN (SELECT DISTINCT AgentID from [WFGCompass].[dbo].[agAgentCycleType] \
                WHERE CycleTypeStatusID = 1 AND EndDate > GETDATE()) c ON a.AgentID = c.AgentID  \
                WHERE ll.NotificationID = %s AND ll.NotificationTypeID = %s \
                ORDER BY AgentNotificationID desc" %(life_line_id, notification_typeid)

        else:
            state_name = get_state_description(state_code, hostname, wfg_database)
            print "State - " + state_name
            str_sql = "SELECT Top 1 a.AgentCodeNumber, ll.AgentNotificationID, ll.AgentID,  ll.NotificationID, \
                n.[Description], ll.NotificationSubType, ll.NotificationTypeID, ll.DateDue, ll.Modified, ll.URLEnable \
                FROM [WFGOnline].[dbo].[WFGLLNotifications] ll \
                INNER JOIN [WFGCompass].[dbo].[agAgent]a ON a.AgentID = ll.AgentID \
                INNER JOIN [WFGOnline].[dbo].[wfgLU_Notification] n ON ll.NotificationID= n.NotificationID \
                INNER JOIN (SELECT DISTINCT AgentID from [WFGCompass].[dbo].[agAgentCycleType] \
                WHERE CycleTypeStatusID = 1 AND EndDate > GETDATE()) c ON a.AgentID = c.AgentID \
                WHERE ll.NotificationID = %s AND ll.NotificationTypeID = %s AND ll.NotificationSubType = '%s' \
                ORDER BY AgentNotificationID desc" % (life_line_id, notification_typeid, state_name)

    rows = connect_to_database(str_sql, hostname, wfg_database)
    if rows:
        for row in rows:
            agent_code_no = row[0]
            agent_notification_id = row[1]
            if life_line_id != "11" and life_line_id != "12":
                date_due_full = str(row[7])
                date_due = convert_the_date(row[7])
                print date_due
    return [agent_code_no, agent_notification_id, date_due, date_due_full]


def get_lifeline_dismiss_notification_agent(life_line_id, hostname, wfg_database):
    agent_code_no = ""
    agent_notification_id = 0

    str_sql = "SELECT Top 1 a.AgentCodeNumber, ll.AgentNotificationID, ll.NotificationID, \
               ll.NotificationTypeID, ll.AgentID \
               FROM [WFGOnline].[dbo].[WFGLLNotifications] ll \
               INNER JOIN [WFGCompass].[dbo].[agAgent] a ON a.AgentID = ll.AgentID \
               WHERE ll.NotificationTypeID <> 3 AND ll.NotificationID = %s \
               GROUP BY ll.AgentID, a.AgentCodeNumber, ll.AgentNotificationID, \
               ll.NotificationID, ll.NotificationTypeID" % life_line_id

    rows = connect_to_database(str_sql, hostname, wfg_database)

    if rows:
        for row in rows:
            agent_code_no = row[0]
            agent_notification_id = row[1]
    return [agent_code_no, agent_notification_id]


def get_lifeline_explanation_agent_id(notification_id, hostname, wfg_database):
    agent_code_no = ""

    str_sql = "SELECT Top 1 a.AgentCodeNumber, ll.AgentID, ll.AgentNotificationID, ll.NotificationID \
               FROM [WFGOnline].[dbo].[WFGLLNotifications] ll \
               INNER JOIN [WFGCompass].[dbo].[agAgent]a ON a.AgentID = ll.AgentID \
               INNER JOIN (SELECT DISTINCT AgentID from [WFGCompass].[dbo].[agAgentCycleType] \
               WHERE CycleTypeStatusID = 1 AND EndDate > GETDATE()) c ON a.AgentID = c.AgentID \
               WHERE ll.NotificationID = %s AND ll.NotificationTypeID <> 3 \
               ORDER BY AgentNotificationID desc" % notification_id
    rows = connect_to_database(str_sql, hostname, wfg_database)

    if rows:
        for row in rows:
            agent_code_no = row[0]
            print agent_code_no
    return agent_code_no


def get_lifeline_explanation_info(agent_code_no, notif_id, state_code, hostname, wfg_database):
    result = ""
    state = ""

    if len(state_code) == 0:
        str_sql = "SELECT ll.* FROM [WFGOnline].[dbo].[WFGLLNotifications] ll \
                   INNER JOIN [WFGCompass].[dbo].[agAgent] a  ON a.AgentID = ll.AgentID \
                   WHERE a.AgentCodeNumber = '%s' AND ll.NotificationID = %s" % (agent_code_no, notif_id)
    else:
        str_state = "SELECT Description FROM [WFGOnline].[dbo].[LU_State_Code] WHERE State_Code = '%s'" % state_code
        rows = connect_to_database(str_state, hostname, wfg_database)
        for row in rows:
            state = row[0]
            print state

        str_sql = "SELECT ll.* FROM [WFGOnline].[dbo].[WFGLLNotifications] ll \
                   INNER JOIN [WFGCompass].[dbo].[agAgent] a ON a.AgentID = ll.AgentID \
                   WHERE a.AgentCodeNumber = '%s' AND ll.NotificationID = %s AND  \
                   ll.NotificationSubType = %s", (agent_code_no, notif_id, state)

    rows = connect_to_database(str_sql, hostname, wfg_database)

    if rows:
        for row in rows:
            result = row[0]
            print result
    return result


def get_lifeline_explanation_description(notif_id, hostname, wfg_database):
    result = ""

    str_sql = "SELECT Explanation FROM [WFGOnline].[dbo].[wfgLU_Notification] \
               WHERE NotificationID = %s" % notif_id

    rows = connect_to_database(str_sql, hostname, wfg_database)

    if rows:
        for row in rows:
            result = row[0]
            if notif_id == '12':
                result = result[:100]
            print result
    return result


def get_lifeline_link_html_id(agent_code_no, notif_id, state_code, hostname, wfg_database):
    result = ""
    state = ""

    if len(state_code) == 0:
        str_sql = "SELECT ll.* FROM [WFGOnline].[dbo].[WFGLLNotifications] ll \
                   INNER JOIN [WFGCompass].[dbo].[agAgent] a  ON a.AgentID = ll.AgentID \
                   WHERE a.AgentCodeNumber = '%s' AND ll.NotificationID = %s" % (agent_code_no, notif_id)
    else:
        str_state = "SELECT Description FROM [WFGOnline].[dbo].[LU_State_Code] WHERE State_Code = %s" % state_code
        rows = connect_to_database(str_state, hostname, wfg_database)
        for row in rows:
            state = row[0]
            print state

        str_sql = "SELECT ll.* FROM [WFGOnline].[dbo].[WFGLLNotifications] ll \
                   INNER JOIN [WFGCompass].[dbo].[agAgent] a ON a.AgentID = ll.AgentID \
                   WHERE a.AgentCodeNumber = '%s' AND ll.NotificationID = %s AND  \
                   ll.NotificationSubType = %s" % (agent_code_no, notif_id, state)

    rows = connect_to_database(str_sql, hostname, wfg_database)
    if rows:
        for row in rows:
            result = row[0]
            print result
    return result


def get_lifeline_html_id(agent_code_no, notif_id, notif_type_id, state_code):
    # *** This function is not completed and not in use ***
    result = ""
    state = ""
    if len(state_code) == 0:
        str_sql = "SELECT Top 1 a.AgentCodeNumber, ll.AgentID, ll.NotificationID, ll.NotificationSubType, \
                   ll.NotificationTypeID, ll.DateDue, ll.AgentNotificationID \
                   FROM [WFGOnline].[dbo].[WFGLLNotifications] ll  \
                   INNER JOIN [WFGCompass].[dbo].[agAgent]a  ON a.AgentID = ll.AgentID \
                   INNER JOIN [WFGCompass].[dbo].[agAgentCycleType] c ON a.AgentID = c.AgentID \
                   WHERE  a.AgentCodeNumber = %s AND  ll.NotificationID = %s AND ll.NotificationTypeID = %s \
                   AND c.CycleTypeStatusID = 1 AND c.EndDate = '01/01/3000'" % (agent_code_no, notif_id, notif_type_id)
    else:
        str_sql = "SELECT Top 1 a.AgentCodeNumber, ll.AgentID, ll.NotificationID, ll.NotificationSubType, \
                   ll.NotificationTypeID, ll.DateDue, ll.AgentNotificationID \
                   FROM [WFGOnline].[dbo].[WFGLLNotifications] ll  \
                   INNER JOIN [WFGCompass].[dbo].[agAgent]a  ON a.AgentID = ll.AgentID \
                   INNER JOIN [WFGCompass].[dbo].[agAgentCycleType] c ON a.AgentID = c.AgentID \
                   WHERE  a.AgentCodeNumber = '%s' AND  ll.NotificationID = %s \
                   AND ll.NotificationTypeID = %s AND ll.NotificationSubType LIKE %s \
                   AND c.CycleTypeStatusID = 1 AND c.EndDate = '01/01/3000'" \
                   % (agent_code_no, notif_id, notif_type_id, state_code)


def get_state_description(state_code, hostname, wfg_database):
    state = ""
    str_sql = "SELECT Description FROM [WFGOnline].[dbo].[LU_State_Code] WHERE State_Code = '%s'" % (state_code)
    rows = connect_to_database(str_sql, hostname, wfg_database)

    if rows:
        for row in rows:
            state = row[0]
    return state


def insert_temp_agent(agent_id, notif_id, state_code, notif_type_id, date_due, modified, url, hostname, wfg_database):
    state_name = ""
    if len(state_code)> 0:
        state_name = get_state_description(state_code, hostname, wfg_database)
        print "State - " + state_name
    conn = pyodbc.connect("DRIVER={SQL Server};SERVER=" + hostname + ";DATABASE=" + wfg_database + ";Trusted_Connection=True")
    cursor = conn.cursor()
    if notif_id == "11":
        print "notif_id = ", notif_id
        cursor.execute("INSERT INTO [WFGOnline].[dbo].[WFGLLNotifications] VALUES \
          (%s, %s, '%s', %s, NULL, '%s', %s)" %(agent_id, notif_id, state_name, notif_type_id, modified, url))
    elif notif_id == "12":
        print "notif_id = ", notif_id
        cursor.execute("INSERT INTO [WFGOnline].[dbo].[WFGLLNotifications] VALUES \
            (%s, %s, '%s', %s, NULL, NULL, %s)" % (agent_id, notif_id, state_name, notif_type_id, url))
    else:
        print "notif_id from else = ", notif_id
        cursor.execute("INSERT INTO [WFGOnline].[dbo].[WFGLLNotifications] VALUES \
            (%s,%s,'%s',%s,'%s','%s',%s)" % (agent_id, notif_id, state_name, notif_type_id, date_due, modified, url))

    conn.commit()
    conn.close()


def lifeline_green_notifications(icount, hostname, wfg_database):
    result = ""
    x = " "
    conn = pyodbc.connect("DRIVER={SQL Server};SERVER=" + hostname + ";DATABASE=" + wfg_database + ";Trusted_Connection=True")
    cursor = conn.cursor()
    print "LL " + "Description" + 39*x + "Line Explanation"
    for i_param in range(icount+1):
        cursor.execute("SELECT ll.NotificationID, n.[Description], ll.DateDue, a.AgentCodeNumber,  \
             ll.NotificationSubType, ll.NotificationTypeID, ll.AgentID, ll.Modified \
             FROM [WFGOnline].[dbo].[WFGLLNotifications] ll \
             INNER JOIN [WFGCompass].[dbo].[agAgent] a ON a.AgentID = ll.AgentID \
             INNER JOIN [WFGOnline].[dbo].[wfgLU_Notification] n ON ll.NotificationID= n.NotificationID \
             INNER JOIN (SELECT DISTINCT AgentID FROM [WFGCompass].[dbo].[agAgentCycleType] \
             WHERE CycleTypeStatusID = 1 AND EndDate > GETDATE()) c ON a.AgentID = c.AgentID \
             WHERE ll.NotificationTypeID = 3 AND ll.NotificationID = %s \
             AND DATEDIFF(d, ll.Modified, GETDATE()) > 7 \
             ORDER BY a.AgentCodeNumber, ll.DateDue desc, ll.NotificationSubType" % i_param)

        rows = cursor.fetchall()
        if rows:
            for row in rows:
                # [1]-Description, [2]-AgentCodeNo
                ll_descr = row[1] + (50 - len(row[1]))*x
                green_date = str(row[7])[:10]
                print i_param, ll_descr, green_date, row[3].strip(), " Green Line Expired"
        else:
            cursor.execute("SELECT Description FROM wfgLU_Notification WHERE NotificationID = %s" % i_param)
            rows = cursor.fetchall()
            if rows:
                for row in rows:
                    print i_param, row[0] + (50 - len(row[0]))*x, "No Life Line Expired Green Notifications found"
    conn.close()
    return result


def lifeline_old_dates(icount, ll_exclude, hostname, wfg_database):
    result = ""
    x = " "

    conn = pyodbc.connect("DRIVER={SQL Server};SERVER=" + hostname + ";DATABASE=" + wfg_database + ";Trusted_Connection=True")
    cursor = conn.cursor()
    print "LL " + "Description" + 40*x + "Due Date" + "     " + "AgentID"
    for i_param in range(icount+1):
        cursor.execute("SELECT ll.NotificationID, n.[Description], ll.DateDue, a.AgentCodeNumber,   \
            ll.NotificationSubType, ll.NotificationTypeID, ll.Modified, ll.AgentID, ll.URLEnable \
            FROM [WFGOnline].[dbo].[WFGLLNotifications] ll \
            INNER JOIN [WFGCompass].[dbo].[agAgent] a ON a.AgentID = ll.AgentID \
            INNER JOIN [WFGOnline].[dbo].[wfgLU_Notification] n ON ll.NotificationID= n.NotificationID \
            INNER JOIN (SELECT DISTINCT AgentID FROM [WFGCompass].[dbo].[agAgentCycleType] \
            WHERE CycleTypeStatusID = 1 AND EndDate > GETDATE()) c ON a.AgentID = c.AgentID \
            WHERE ll.NotificationTypeID <> 3 AND ll.NotificationID = %s \
            AND ll.DateDue <  '01-24-2014' AND ll.NotificationID NOT IN (%s) \
            ORDER BY a.AgentCodeNumber, ll.DateDue desc, ll.NotificationSubType" % (i_param, ll_exclude))

        rows = cursor.fetchall()
        if rows:
            for row in rows:
                # [0]-NotificationID, [1]-Description, [2]-AgentCodeNo
                lldescr = row[1] + (50 - len(row[1]))*x
                olddate = str(row[2])[:10]
                print i_param, lldescr, olddate, 3*x, row[3]
        else:
            cursor.execute("SELECT Description FROM wfgLU_Notification WHERE NotificationID = %s \
                           AND NotificationID NOT IN (%s)" % (i_param, ll_exclude))

            rows = cursor.fetchall()
            if rows:
                for row in rows:
                    print i_param, row[0] + (50 - len(row[0]))*x, "No Life Line Old Dates found"
    conn.close()
    return result


def lifeline_old_dates_archived(icount, ll_archived, hostname, wfg_database):
    result = ""
    x = " "

    conn = pyodbc.connect("DRIVER={SQL Server};SERVER=" + hostname + ";DATABASE=" + wfg_database + ";Trusted_Connection=True")
    cursor = conn.cursor()
    print "LL " + "Description" + 40*x + "Due Date" + "     " + "AgentID"
    for i_param in range(icount+1):
        cursor.execute("SELECT llh.NotificationID, n.[Description], llh.DateDue, a.AgentCodeNumber, llh.AgentID, \
            llh.NotificationSubType, llh.NotificationTypeID, llh.ArchivedDate, llh.IsDismissed, llh.Modified \
            FROM [WFGOnline].[dbo].[WFGLLNotificationsHistory] llh \
            INNER JOIN [WFGCompass].[dbo].[agAgent] a ON a.AgentID = llh.AgentID \
            INNER JOIN [WFGOnline].[dbo].[wfgLU_Notification] n ON n.NotificationID= llh.NotificationID \
            INNER JOIN (SELECT DISTINCT AgentID FROM [WFGCompass].[dbo].[agAgentCycleType] \
            WHERE CycleTypeStatusID = 1 AND EndDate > GETDATE()) c ON a.AgentID = c.AgentID \
            WHERE llh.NotificationTypeID <> 3 AND llh.NotificationID = %s \
            AND llh.DateDue <  '01-24-2014' AND llh.DateDue <  '01-24-2014' AND llh.NotificationID NOT IN (%s) \
            ORDER BY a.AgentCodeNumber, llh.Modified desc, llh.NotificationSubType" % (i_param, ll_archived))


        rows = cursor.fetchall()
        if rows:
            for row in rows:
                # [0]-NotificationID, [1]-Description, [2]-AgentCodeNo
                ll_descr = row[1] + (50 - len(row[1]))*x
                arch_date = str(row[2])[:10]
                print i_param, ll_descr, arch_date, 3*x, row[3]
        else:
            cursor.execute("SELECT Description FROM wfgLU_Notification WHERE NotificationID = %s \
                     AND NotificationID NOT IN (%s)" % (i_param, ll_archived))
            rows = cursor.fetchall()
            if rows:
                for row in rows:
                    print i_param, row[0] + (50 - len(row[0]))*x, "No Life Line Old Archived Dates found"

    conn.close()
    return result


def get_dismissed_reason(dismiss_index, hostname, wfg_database):
    result = ""

    str_sql = "SELECT Description FROM [WFGOnline].[dbo].[wfgLU_NotificationDismissReason] \
               WHERE DismissReasonID = %s" % dismiss_index

    rows = connect_to_database(str_sql, hostname, wfg_database)

    if rows:
        for row in rows:
            result = row[0]
    else:
        print "No Dismiss Reason found"
    return result


def get_archived_datedue(archived_task_html_id, hostname, wfg_database):
    result = ""

    str_sql = "SELECT DateDue FROM [WFGOnline].[dbo].[WFGLLNotificationsHistory] \
               WHERE AgentNotificationID = %s" % archived_task_html_id

    rows = connect_to_database(str_sql, hostname, wfg_database)

    if rows:
        for row in rows:
            result = convert_the_date(row[0])
    else:
        print "No Life Line Old Archived Dates found"
    return result


def lifeline_pcodes(notif_id, p_codes, p_compname, hostname, wfg_database):
    result = ""
    x = " "

    str_sql = "SELECT ll.NotificationID, n.[Description], ll.DateDue, a.AgentCodeNumber, ll.NotificationSubType, \
              ll.NotificationTypeID, ll.Modified, ll.AgentID \
              FROM [WFGOnline].[dbo].[WFGLLNotifications] ll \
              INNER JOIN [WFGCompass].[dbo].[agAgent] a ON a.AgentID = ll.AgentID \
              INNER JOIN [WFGOnline].[dbo].[wfgLU_Notification] n ON ll.NotificationID= n.NotificationID \
              INNER JOIN (SELECT DISTINCT AgentID FROM [WFGCompass].[dbo].[agAgentCycleType] \
              WHERE CycleTypeStatusID = 1 AND EndDate > GETDATE()) c ON a.AgentID = c.AgentID \
              WHERE ll.NotificationID IN (%s) \
              AND LEFT(ll.NotificationSubType, 2) IN (%s) \
              AND LEFT(ll.NotificationSubType, 3) NOT IN (%s) \
              ORDER BY ll.NotificationID,  n.[Description], ll.NotificationSubType, a.AgentCodeNumber" \
              % (notif_id, p_codes, p_compname)

    rows = connect_to_database(str_sql, hostname, wfg_database)

    if rows:
        for row in rows:
            # [1]-Description, [2]-AgentCodeNo, [3]-Description
            lldescr = row[1] + (50 - len(row[1]))*x
            pcodedate = str(row[2])[:10]
            print notif_id, lldescr, pcodedate, 3*x, row[3], row[4]
    else:
            str_sql = "SELECT Description FROM wfgLU_Notification WHERE NotificationID = %s" % notif_id
            rows = connect_to_database(str_sql, hostname, wfg_database)
            # cursor.execute("SELECT Description FROM wfgLU_Notification WHERE NotificationID = ?", notif_id)
            # rows = cursor.fetchall()
            if rows:
                for row in rows:
                    print notif_id, row[0] + (50 - len(row[0]))*x, "No PCode found"
    return result


def lifeline_records_duplications(i_count, hostname, wfg_database):
    result = ""
    x = " "

    conn = pyodbc.connect("DRIVER={SQL Server};SERVER=" + hostname + ";DATABASE=" + wfg_database + ";Trusted_Connection=True")
    cursor = conn.cursor()
    print "LL " + "Description" + 40*x + "Line Explanation" + 4*x + "AgentID"
    for i_param in range(i_count + 1):
        cursor.execute("SELECT ll.NotificationID, n.[Description], a.AgentCodeNumber, \
            COUNT(a.AgentCodeNumber) AS TasksCount,  ll.NotificationSubType \
            FROM [WFGOnline].[dbo].[WFGLLNotifications] ll \
            INNER JOIN [WFGCompass].[dbo].[agAgent] a ON a.AgentID = ll.AgentID \
            INNER JOIN [WFGOnline].[dbo].[wfgLU_Notification] n ON ll.NotificationID= n.NotificationID \
            INNER JOIN (SELECT DISTINCT AgentID from [WFGCompass].[dbo].[agAgentCycleType] where CycleTypeStatusID = 1 \
            AND EndDate > GETDATE()) c ON a.AgentID = c.AgentID \
            WHERE ll.NotificationTypeID <> 3 AND ll.NotificationID = %s \
            GROUP BY a.AgentCodeNumber, ll.NotificationID, n.Description, ll.NotificationSubType \
            HAVING  COUNT(a.AgentCodeNumber) > 1 \
            ORDER BY a.AgentCodeNumber,  ll.NotificationSubType" % i_param)

        rows = cursor.fetchall()
        if rows:
            for row in rows:
                # [0]-NotificationID,[1]-Description, [2]-AgentCodeNo, [3]-## of Notifications
                ll_descr = row[1] + (50 - len(row[1]))*x
                print i_param, "", ll_descr, row[3], "duplications found", row[2]
        else:
            cursor.execute("SELECT Description FROM wfgLU_Notification WHERE NotificationID = %s" % i_param)

            rows = cursor.fetchall()
            if rows:
                for row in rows:
                    print i_param, "", row[0] + (50 - len(row[0]))*x, "No Duplication found"
    conn.close()
    return result


def lifeline_iul_annuity_yellow_notifications(notif_id1, notif_id2, hostname, wfg_database):
    result = ""
    x = " "

    str_sql = "SELECT NotificationID, Description FROM wfgLU_Notification \
               WHERE NotificationID IN (%s, %s)" % (notif_id1, notif_id2)
    ll_rows = connect_to_database(str_sql, hostname, wfg_database)

    print "LL " + "Description" + 20 * x + "Agent No"
    for row1 in ll_rows:
        str_sql = "SELECT ll.NotificationID, n.[Description], ll.DateDue, a.AgentCodeNumber, ll.NotificationSubType, \
                   ll.NotificationTypeID, ll.Modified, ll.AgentID \
                   FROM [WFGOnline].[dbo].[WFGLLNotifications] ll \
                   INNER JOIN [WFGCompass].[dbo].[agAgent] a ON a.AgentID = ll.AgentID \
                   INNER JOIN [WFGOnline].[dbo].[wfgLU_Notification] n ON ll.NotificationID= n.NotificationID \
                   INNER JOIN (SELECT DISTINCT AgentID FROM [WFGCompass].[dbo].[agAgentCycleType] \
                   WHERE CycleTypeStatusID = 1 AND EndDate > GETDATE()) c ON a.AgentID = c.AgentID \
                   WHERE ll.NotificationTypeID = 2 AND ll.NotificationID = %s \
                   ORDER BY ll.NotificationID, a.AgentCodeNumber" % row1[0]

        rows = connect_to_database(str_sql, hostname, wfg_database)
        if rows:
            for row in rows:
                # [1]-Description, [2]-AgentCodeNo, [3]-Description
                lldescr = row[1] + (30 - len(row[1]))*x
                print row[0], lldescr, row[3]
        else:
            print row1[0], row1[1] + (30 - len(row1[1]))*x, "No Yellow Notifications found"
    return result


def select_agent_id_info(agent_id1, agent_id2, hostname, wfg_database):
    result = ""
    print "First agent - " + agent_id1
    print "Second agent - " + agent_id2

    str_sql = "SELECT AgentCodeNumber,FirstName,LastName FROM agAgent WHERE AgentID IN(%s,%s)" % agent_id1, agent_id2
    rows = connect_to_database(str_sql, hostname, wfg_database)
    if rows:
        for row in rows:
            print "Row " + str(row)
            result = row[0], row[1], row[2]
            print "Result - " + str(result)
    return result


def select_agent_id(agent_id, hostname, wfg_database):
    result = ""
    print "Selected agent - " + agent_id

    str_sql = "SELECT AgentCodeNumber,FirstName,LastName FROM agAgent WHERE AgentID = %s" % agent_id
    rows = connect_to_database(str_sql, hostname, wfg_database)

    if rows:
        for row in rows:
            result = row[0]
            print "Result - " + str(result)
    return result


def select_eo_agent_without_balance(country, current_date, wf_hostname, wf_database):
    result = ""
    day = ""
    package_id = ""
    current_day = current_date[8:]
    if current_day[0] == "0":
         current_day = current_day[1:2]
    else:
        current_day = current_day[0:2]

    if country == "US":
         package_id = 15
    elif country == "CA":
         package_id = 16
    elif country == "PR":
         package_id = 20

    str_sql = "SELECT TOP 1 AgentID as AgentCodeNumber, EOBalance, BuildDate, PM_EOPayment, Comp_EOPayment \
        FROM [WFGWorkflow].[dbo].[Agent_EandO_DailyWorkTable] \
        WHERE Country = '%s' AND EOBalance = 0 \
        AND LEFT(AgentID, 2) >= '%s' AND AgentID NOT IN \
        (SELECT a.AgentID FROM [WFGOnline].[dbo].[regRegistration] r \
        INNER JOIN  [WFGOnline].[dbo].[regAgentInfo] a ON r.AgentInfoID=a.AgentInfoID \
        WHERE r.PackageID = '%s' AND Status ='N') AND AgentID NOT IN \
        (SELECT s.CreatedBy FROM [CRDBCOMP03\CRDBWFGOMOD].[WFGECommerce].[dbo].peShoppingCart s \
        INNER JOIN [CRDBCOMP03\CRDBWFGOMOD].[WFGOnlineCMS].[dbo].Wfg_PaymentEngine_PaymentSourcePartRecord p \
        ON p.Source = s.Source \
        WHERE s.Created > (GETDATE()-1) AND ItemCode IS NOT NULL) \
        ORDER BY AgentID" % (country, current_day, package_id)

    rows = connect_to_database(str_sql, wf_hostname, wf_database)
    if rows:
        for row in rows:
            result = row[0]
            print "Result - " + str(result)
    return result


def select_eo_agent_to_unsubscribe(country, current_date, wf_hostname, wf_database, data_refresh_date):
    result = ""
    package_id = ""

    current_day = current_date[8:]
    if current_day[0] == "0":
        current_day = current_day[1:2]
    else:
        current_day = current_day[0:2]

    if country == "US":
        package_id = 15
    elif country == "CA":
        package_id = 16
    elif country == "PR":
        package_id = 20

    str_sql = "SELECT TOP 1 a.AgentID as AgentCodeNumber, r.PackageID, r.Status, r.StartDate \
        FROM [CRDBCOMP03\CRDBWFGOMOD].[WFGOnline].[dbo].[regRegistration] r \
        INNER JOIN [CRDBCOMP03\CRDBWFGOMOD].[WFGOnline].[dbo].[regAgentInfo] a ON r.AgentInfoID=a.AgentInfoID \
        WHERE r.PackageID = '%s' AND r.StartDate >= '%s' AND r.Status = 'N' \
        ORDER BY a.AgentID, r.StartDate desc " % (package_id, data_refresh_date)

    rows = connect_to_database(str_sql, wf_hostname, wf_database)
    if rows:
        for row in rows:
            result = row[0]
            print "Result - " + str(result)
    return result


def select_eo_agent_with_balance(country, current_date, wf_hostname, wf_database, comp_hostname, comp_database):
    result = ""
    current_day = ""
    package_id = 0
    cycle_typeid = ""
    company_string = ""
    max_date = ""

    current_day = current_date[8:]
    if current_day[0] == "0":
        current_day = current_day[1:2]
    else:
        current_day = current_day[0:2]

    if country == "US":
        package_id = 15
        cycle_typeid = 1
        company_string = "'P00134','P01003','P01015','P01043'"
    elif country == "CA":
        package_id = 16
        cycle_typeid = 2
        company_string = "'P01003','P01015','P01043','PI0502','PI1192'"
    elif country == "PR":
        package_id = 20
        cycle_typeid = 3
        company_string = "'PI0175','PI1169'"

    # Get the latest Cycle date
    str_sql = "SELECT MAX(CycleDate) as MaxCycleDate FROM [CRDBCOMP03\CRDBCOMPMOD].[Compass].[dbo].[cmCycle] \
              WHERE CycleStatusID = 2 AND CycleTypeID = %s " % cycle_typeid

    rows = connect_to_database(str_sql, comp_hostname, comp_database)
    if rows:
        for row in rows:
            max_date = row[0]
            print "Max Date - " + str(max_date)

    str_sql = "SELECT TOP 1 a.AgentCodeNumber, bh.EndingAccountBalance, c.CompanyCodeNumber, c.CompanyName \
        FROM [CRDBCOMP03\CRDBCOMPMOD].[Compass].[dbo].[VHcmBalanceHistory] bh \
        INNER JOIN [CRDBCOMP03\CRDBCOMPMOD].[Compass].[dbo].[cmCompany] c ON c.CompanyID = bh.CompanyID \
        AND c.CompanyCodeNumber IN (%s) \
        INNER JOIN [CRDBCOMP03\CRDBCOMPMOD].[Compass].[dbo].[agAgent] a ON a.AgentID = bh.AgentID \
        INNER JOIN [CRDBCOMP03\CRDBCOMPMOD].[Compass].[dbo].[agAgentCycleType] act ON act.AgentID = bh.AgentID \
        INNER JOIN[CRDBCOMP03\CRDBCOMPMOD].[Compass].[dbo].[luCycleTypeStatus] lu \
        ON lu.CycleTypeStatusID = act.CycleTypeStatusID \
        WHERE act.CycleTypeID IN ('%s') AND lu.CycleTypeStatus = 'A' AND act.StartDate <= GETDATE() \
        AND act.EndDate >= GETDATE() AND bh.CycleDate = '%s' AND bh.EndingAccountBalance < 0 \
        AND LEFT(a.AgentCodeNumber, 2)> = '%s' AND a.AgentCodeNumber NOT IN \
        (SELECT a.AgentID FROM [CRDBCOMP03\CRDBWFGOMOD].[WFGOnline].[dbo].[regRegistration] r \
        INNER JOIN  [CRDBCOMP03\CRDBWFGOMOD].[WFGOnline].[dbo].[regAgentInfo] a ON r.AgentInfoID=a.AgentInfoID \
        WHERE r.PackageID = %s AND Status ='N') \
        AND a.AgentCodeNumber NOT IN \
        (SELECT Agent_ID FROM [CRDBCOMP03\CRDBWFGOMOD].[WFGOnline].[dbo].[EO_AgentPayments]) \
        AND a.AgentCodeNumber NOT IN (SELECT s.CreatedBy FROM \
        [CRDBCOMP03\CRDBWFGOMOD].[WFGECommerce].[dbo].peShoppingCart s \
        INNER JOIN [CRDBCOMP03\CRDBWFGOMOD].[WFGOnlineCMS].[dbo].Wfg_PaymentEngine_PaymentSourcePartRecord p \
        ON p.Source = s.Source \
        WHERE s.Created > (GETDATE()-1) AND ItemCode IS NOT NULL) \
        ORDER BY a.AgentCodeNumber, c.CompanyCodeNumber, bh.EndingAccountBalance, \
        bh.CycleDate desc " % (company_string, cycle_typeid, max_date, current_day, package_id)

    rows = connect_to_database(str_sql, wf_hostname, wf_database)
    if rows:
        for row in rows:
            result = row[0]
            print "Result - " + str(result)
    return result


def select_tfa_affiliation_agent (current_date, comp_hostname, comp_database):
    result = ""
    current_day = ""
    max_date = ""

    current_day = current_date[8:]
    if current_day[0] == "0":
        current_day = current_day[1:2]
    else:
        current_day = current_day[0:2]

    # Get the latest Cycle date
    str_sql = "SELECT MAX(CycleDate) as MaxCycleDate FROM [CRDBCOMP03\CRDBCOMPMOD].[Compass].[dbo].[cmCycle] \
                 WHERE CycleStatusID = 2 AND CycleTypeID = 1"

    rows = connect_to_database(str_sql, comp_hostname, comp_database)
    if rows:
        for row in rows:
            max_date = row[0]
            print "Max Date - " + str(max_date)

    str_sql = "SELECT TOP 1 a.AgentCodeNumber, bh.EndingAccountBalance, c.CompanyCodeNumber, c.CompanyName \
           FROM [CRDBCOMP03\CRDBCOMPMOD].[Compass].[dbo].[VHcmBalanceHistory] bh \
           INNER JOIN [CRDBCOMP03\CRDBCOMPMOD].[Compass].[dbo].[cmCompany] c ON c.CompanyID = bh.CompanyID \
           AND c.CompanyCodeNumber IN ('P01190') \
           INNER JOIN [CRDBCOMP03\CRDBCOMPMOD].[Compass].[dbo].[agAgent] a ON a.AgentID = bh.AgentID \
           INNER JOIN [CRDBCOMP03\CRDBCOMPMOD].[Compass].[dbo].[agAgentCycleType] act ON act.AgentID = bh.AgentID \
           INNER JOIN[CRDBCOMP03\CRDBCOMPMOD].[Compass].[dbo].[luCycleTypeStatus] lu ON lu.CycleTypeStatusID = act.CycleTypeStatusID \
           WHERE act.CycleTypeID IN ('1') AND lu.CycleTypeStatus = 'A' AND act.StartDate <= GETDATE() \
           AND act.EndDate >= GETDATE() AND bh.CycleDate = '%s' AND bh.EndingAccountBalance < 0 \
           AND LEFT(a.AgentCodeNumber, 2)> = '%s' \
           AND a.AgentCodeNumber NOT IN \
           (SELECT Agent_ID FROM [CRDBCOMP03\CRDBWFGOMOD].[WFGOnline].[dbo].[EO_AgentPayments]) \
           AND a.AgentCodeNumber NOT IN (SELECT s.CreatedBy FROM \
           [CRDBCOMP03\CRDBWFGOMOD].[WFGECommerce].[dbo].peShoppingCart s \
           INNER JOIN [CRDBCOMP03\CRDBWFGOMOD].[WFGOnlineCMS].[dbo].Wfg_PaymentEngine_PaymentSourcePartRecord p \
           ON p.Source = s.Source \
           WHERE s.Created > (GETDATE()-1) AND ItemCode IS NOT NULL) \
           ORDER BY a.AgentCodeNumber, c.CompanyCodeNumber, bh.EndingAccountBalance, \
           bh.CycleDate desc " % (max_date, current_day)

    rows = connect_to_database(str_sql, comp_hostname, comp_database)
    if rows:
        for row in rows:
            result = row[0]
            print "Result - " + str(result)
    return result
