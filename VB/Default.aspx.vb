Imports DevExpress.Data
Imports DevExpress.Web
Imports System
Imports System.Collections.Generic
Imports System.Linq
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls

Partial Public Class _Default
	Inherits System.Web.UI.Page

	Public ReadOnly Property Summaries() As Dictionary(Of String, SummaryItemType)
		Get
			If Session("summaries") Is Nothing Then
				Session("summaries") = New Dictionary(Of String, SummaryItemType)()
			End If
			Return TryCast(Session("summaries"), Dictionary(Of String, SummaryItemType))
		End Get
	End Property
	Protected Sub Page_Init(ByVal sender As Object, ByVal e As EventArgs)
		If Not IsPostBack Then
			Session.Clear()
		End If

		RestoreSummaries(ASPxGridView1)
	End Sub
	Protected Sub ASPxGridView1_CustomCallback(ByVal sender As Object, ByVal e As ASPxGridViewCustomCallbackEventArgs)
		Dim grid = TryCast(sender, ASPxGridView)

		If e.Parameters.StartsWith("groupFooter") Then
			Dim fieldName = e.Parameters.Split("|"c)(1)
			Dim selectedType = e.Parameters.Split("|"c)(2)
			Dim summaryType = GetSummaryType(selectedType)
			Dim key = fieldName & "|" & selectedType

			If Summaries.ContainsKey(key) Then
				Summaries.Remove(key)
			Else
				Summaries.Add(key, summaryType)
			End If

			If summaryType = SummaryItemType.None Then
				Dim columnSummaries = Summaries.Where(Function(x) x.Key.StartsWith(fieldName)).ToList()
				For Each item As KeyValuePair(Of String, SummaryItemType) In columnSummaries
					Summaries.Remove(item.Key)
				Next item
			End If

			grid.GroupSummary.Clear()
			RestoreSummaries(grid)
		End If
	End Sub
	Protected Sub ASPxGridView1_BeforeGetCallbackResult(ByVal sender As Object, ByVal e As EventArgs)
		AssignClasses()
	End Sub
	Protected Sub ASPxGridView1_PreRender(ByVal sender As Object, ByVal e As EventArgs)
		AssignClasses()
	End Sub

	Private Sub RestoreSummaries(ByVal grid As ASPxGridView)
		For Each summary As KeyValuePair(Of String, SummaryItemType) In Summaries
			Dim fieldName = summary.Key.Split("|"c)(0)
			grid.GroupSummary.Add(New ASPxSummaryItem(fieldName, summary.Value) With {.ShowInGroupFooterColumn = fieldName})
		Next summary
	End Sub
	Protected Function GetSummaryType(ByVal type As String) As SummaryItemType
		Dim summaryType = New SummaryItemType()
		Select Case type
			Case "Min"
				summaryType = SummaryItemType.Min
			Case "Sum"
				summaryType = SummaryItemType.Sum
			Case "Average"
				summaryType = SummaryItemType.Average
			Case "Max"
				summaryType = SummaryItemType.Max
			Case "Count"
				summaryType = SummaryItemType.Count
			Case "None"
				summaryType = SummaryItemType.None
		End Select
		Return summaryType
	End Function

	Private Sub AssignClasses()
		For Each column As GridViewDataColumn In ASPxGridView1.Columns
			column.GroupFooterCellStyle.CssClass = "myFooter|" & column.VisibleIndex & "|"
			Dim appliedSummaries = Summaries.Where(Function(x) x.Key.StartsWith(column.FieldName)).Select(Function(x) x.Value.ToString()).ToList()
			If appliedSummaries.Count > 0 Then
				column.GroupFooterCellStyle.CssClass &= String.Join("&", appliedSummaries)
			End If
			column.GroupFooterCellStyle.CssClass &= "|"
		Next column
	End Sub
End Class