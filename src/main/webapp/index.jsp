<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>SQL Gateway</title>
</head>
<body>
<h2>SQL Gateway</h2>

<form action="sqlGateway" method="post">
    <textarea name="sqlStatement" rows="5" cols="60"><%= 
        session.getAttribute("sqlStatement") != null 
        ? session.getAttribute("sqlStatement") : "" %></textarea>
    <br>
    <input type="submit" value="Execute">
</form>

<h3>Result:</h3>
<%= session.getAttribute("sqlResult") != null 
    ? session.getAttribute("sqlResult") 
    : "" %>

</body>
</html>
