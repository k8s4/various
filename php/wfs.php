<?php

// Replace the value's of these variables with your own data:
    $dsn = "MSSQL"; // Data Source Name (DSN) from the file /usr/local/zend/etc/odbc.ini
    $user = "web"; // MSSQL database user
    $password = "********"; // MSSQL user password


$datetimeFormat = "d/m/Y H:i:s";
$refreshTag = "<meta http-equiv='refresh' content='5' />";
$type = "Active";
$tableData = "";
$flagLimit = "";
$rawCount = 0;

$conn = odbc_connect($dsn, $user, $password);

//Verify connection
//if ($connect) {
//    echo "Connection established.";
//    odbc_close($connect);
//} else {
//    die("Connection could not be established.");
//}

if ($_POST) {
        switch ($_POST['type']) {
                case "Active":
                                $type = "Active";
                        break;
                case "Queued":
                                $type = "Queued";
                                $refreshTag = "";
                        break;
                case "Completed":
                                $type = "Completed";
                                $refreshTag = "";
                                $flagLimit = "TOP 5000";
                        break;
                case "Fatal":
                                $type = "Fatal";
                                $refreshTag = "";
                        break;
                default:
                                $type = "Active";
                        break;
        }
}

//declare the SQL statement that will query the database
$sql .= "SELECT ".$flagLimit." [WFSDB].[dbo].[TableJob].[serviceID], [WFSDB].[dbo].[TableJob].[name], [WFSDB].[dbo].[TableJob].[status], [WFSDB].[dbo].[TableJob].[priority], [WFSDB].[dbo].[TableJob].[created]";
$sql .= ",[WFSDB].[dbo].[TableJob].[started], [WFSDB].[dbo].[TableJob].[lastUpdate], [WFSDB].[dbo].[TableJob].[type]";
$sql .= ",sum([WFSDB].[dbo].[TableTask].[progress])/count([WFSDB].[dbo].[TableTask].[progress]) AS [progress]";
$sql .= "FROM [WFSDB].[dbo].[TableJob]";
$sql .= "LEFT JOIN [WFSDB].[dbo].[TableTask] ON [WFSDB].[dbo].[TableJob].[guid] = [WFSDB].[dbo].[TableTask].[jobID]";
$sql .= "WHERE [WFSDB].[dbo].[TableJob].[status] = '".$type."' AND [WFSDB].[dbo].[TableJob].[type] = 'Varied'";
$sql .= "GROUP BY [WFSDB].[dbo].[TableJob].[guid],[WFSDB].[dbo].[TableJob].[serviceID],[WFSDB].[dbo].[TableJob].[name],[WFSDB].[dbo].[TableJob].[type],[WFSDB].[dbo].[TableJob].[meta],[WFSDB].[dbo].[TableJob].[status]";
$sql .= ",[WFSDB].[dbo].[TableJob].[priority],[WFSDB].[dbo].[TableJob].[lastUpdate],[WFSDB].[dbo].[TableJob].[created],[WFSDB].[dbo].[TableJob].[started]";
$sql .= "ORDER BY [WFSDB].[dbo].[TableJob].[created] DESC";

//execute the SQL query and return records
$rs = odbc_exec($conn, $sql) or die('A error occured: ' . odbc_errormsg());

//Show results in table
while ($record =  odbc_fetch_array($rs) ) {
        $rawCount += 1;
        if (isEven($rawCount)) { $rawColor = "#262626"; } else { $rawColor = "#353535"; }
        $tableData .= "<tr bgcolor='".$rawColor."'><td>".$record['serviceID']."</td>";
        $tableData .= "<td>".$record['name']."</td>";
        $tableData .= "<td align=center>".$record['status']."</td>";
        $tableData .= "<td align=center>".$record['progress']."</td>";
        $tableData .= "<td align=center>".$record['priority']."</td>";
        $tableData .= "<td align=center>".date($datetimeFormat, ticks_to_time($record['created']) - 10800)."</td>";
        $tableData .= "<td align=center>".date($datetimeFormat, ticks_to_time($record['started']) - 10800)."</td>";
        $tableData .= "<td align=center>".date($datetimeFormat, ticks_to_time($record['lastUpdate']) - 10800)."</td></tr>";
}

odbc_close($conn);

// Prepare HTML output
echo "  <html>  <head> <title>DashWFS   </title><meta http-equiv='Content-Type' content='text/html;charset=UTF-8'>".$refreshTag;
echo "<style type='text/css'>* {font-family: Segoe UI} td {padding: 3px 15px 3px 15px; color:#d2d2d2;}</style>";
echo "</head> <body bgcolor='#282726'><font color='#d2d2d2'>";
echo "<H1>DashWFS</H1>";
echo "<form action='' method='post'><p>";
echo "<input type='submit' name='type' value='Active'>";
echo "<input type='submit' name='type' value='Queued'>";
echo "<input type='submit' name='type' value='Fatal'>";
echo "<input type='submit' name='type' value='Completed'>";
echo "  Total Jobs: ".$rawCount;
echo "</p></form>";
echo "<table border=1px  cellpadding='5' cellspacing='0.5px'>";

// If no jobs print it
if ($tableData == "") {
        $tableData = "<tr><td color='#d2d2d2'><font size='5'>Whoops there is nothing!</font></td></tr>";
} else {
        echo "<tr bgcolor='#262626'><td>Node</td><td>Name</td><td>Status</td><td>Progress</td><td>Priority</td><td>Created Date</td><td>Started Date</td><td>Last Update</td></tr>";
}
echo $tableData;
echo "</table></font></body></html>";

// get unix time from 01-01-0001 00:00
function ticks_to_time($ticks) {
    return floor(($ticks - 621355968000000000) / 10000000);
}

function isEven($value) {
        return ($value%2 == 0);
}


?>