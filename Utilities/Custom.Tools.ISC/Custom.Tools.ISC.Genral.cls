/// Created By: Oscar Rondon, 21/03/2024, CCR N/A, JIRA N/A
Class Custom.Tools.ISC.General [ Abstract ]
{

/// Created By: Oscar Rondon, 21/03/2024, CCR N/A, JIRA CELTECH-4313
/// Massive Update for Appoitments status by year
ClassMethod RBAppoitmentMassStatusChange(Year As %Integer, OldStatus As %String, NewStatus As %String) As %Status
{
	Set sc = $$$OK
	Try{
	
		Set (tApptRowid, tPatientId) = ""
		
		&sql(Declare tAppoitmens Cursor  for 
			select 
			%NOLOCK APPT_RowId, APPT_PAPMI_DR
			into :tApptRowid, :tPatientId
			from sqluser.RB_Appointment
			where year(APPT_TransDate) = :Year
			and APPT_Status = :OldStatus
		)
		
		&sql(OPEN tAppoitmens)
			Quit:(SQLCODE'=0)

		Do 
		{   
			&sql(FETCH tAppoitmens)

			If tApptRowid'=""
			{
				&SQL(update %NOTRIGGER sqluser.RB_Appointment  set APPT_Status = :NewStatus where APPT_RowId = :tApptRowid)
					If SQLCODE=0
					{
						Set horolog=$HOROLOG
						Set date=+horolog ///	$zdate(+horolog,4)
						Set time=$PIECE(horolog,",",2)	///$ztime($piece(horolog,",",2),2)
						
						Set obj=##class(questionnaire.QCLXXTPEC).%New()
						If $GET(%d(4))'="" Set obj.QUESPAPatMasDR=##class(User.PAPatMas).%OpenId($GET(%d(4))) ///	PatientID
						//if $get(%d(1))'="" set obj.QUESRBAppointmentDR=##class(User.RBAppointment).%OpenId($get(%d(1)))	/// Appointment ID
						Set obj.Q01=date
						Set obj.Q02=time
						Set obj.Q03=$USERNAME
						//	2021-04-13	change status S > Z		TC-290911
						Set obj.Q04=NewStatus ///	APPT_Status
						Set obj.Q05=tPatientId ///	PatientID
						Set obj.Q06=tApptRowid	/// Appointment ID
						Do obj.%Save()
					}
			}
		} While (SQLCODE=0)
		&sql(CLOSE tAppoitmens)
	}
	Catch(ex){
		Set sc = $$$ADDSC(sc,ex.AsStatus())
		Do ##class(Region.CLXX.Integration.Nexus.CS.EventLog).LogStatus(sc, 
			"RBAppoitmentMassStatusChange", 
			"Custom.Tools.ISC.General")		
	}
	Quit sc
}

}