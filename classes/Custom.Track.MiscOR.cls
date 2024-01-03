/// Class for code testing
/// do ##class(Custom.Track.MiscOR).tryHang()
Class Custom.Track.MiscOR Extends %RegisteredObject
{

ClassMethod tryHang() As %String
{
		Kill ^zOscarRondon
		Set sResp = "Fail"
		Set ^zOscarRondon($ZDATETIME($NOW()), 1, "Start") = $ZDATETIME($NOW())
		Hang 10
		Set ^zOscarRondon($ZDATETIME($NOW()), 1, "End") = $ZDATETIME($NOW())
		Set sResp = "Ok"
	 	Quit sResp
}

}

