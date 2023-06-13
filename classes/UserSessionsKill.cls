///https://groups.google.com/g/intersystems-public-cache/c/OKKbGPZvtAM?pli=1
///do ##class(Custom.SessionKill).withoutTimeout()

Class Custom.SessionKill Extends %RegisteredObject
{

ClassMethod withoutTimeout() As %String
{
	Set sResp = "Fail"
	Set sqlQuery = ##class(%SQL.Statement).%New()
 	Set status = sqlQuery.%PrepareClassQuery("%CSP.Session","SessionInfo")
 	If status = 1 {
 		Set sessionList = sqlQuery.%Execute()
 		Set userQty = 0
 		While sessionList.%Next() {
	 		Set userQty = userQty + 1
	 		Set sessionID = sessionList.%Get("ID")
	 		Set userSession=##class(%CSP.Session).%OpenId(sessionID)
	 		If userSession '= ""
	 		{
	 			If userSession.AppTimeout = 0 {
		 			Do ##class(%CSP.Session).%DeleteId(sessionID)
	 			}
	 		}
 		}
 		Set sResp = "ok"
 	}
 	Quit sResp
}

}