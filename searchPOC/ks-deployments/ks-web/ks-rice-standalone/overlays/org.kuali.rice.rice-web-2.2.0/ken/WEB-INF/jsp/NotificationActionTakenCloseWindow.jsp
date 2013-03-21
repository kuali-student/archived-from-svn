<%--

    Copyright 2005-2012 The Kuali Foundation

    Licensed under the Educational Community License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.opensource.org/licenses/ecl2.php

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

--%>
<%@ include file="Include.jsp"%>

<html>
<head>
<title>Kuali Enterprise Notification - Notification Action Taken</title>
<meta name="Author" content="Aaron Godert (ag266 at cornell dot edu)">
<link href="css/notification.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
	self.opener.location.reload();
	self.close();
</script>
</head>
<body>

<div id="pagebody">
		<!-- actually render page if javascript is turned off -->
       	<center>
	       	<br/>
	       	<br/>
	       	<br/>
	       	<br/>
	       	<br/>
	       	<b>The action taken on this notification was successful!</b>
	       	<br/>
	       	<br/>
	       	<b>Please close this window and refresh your action list if it was not refreshed automatically.</b>
	       	<br/>
	       	<br/>
	       	<br/>
	       	<br/>
	       	<br/>
	       	<br/>
	       	<br/>
	       	<br/>
	       	<a href="javascript:self.close()">
	         	<img src="images/buttonsmall_close.gif" border="0" alt="close" />
            </a>  
       	</center>
</div>

</body>
</html>
