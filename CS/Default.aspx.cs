using DevExpress.Data;
using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{
    public Dictionary<string, SummaryItemType> Summaries
    {
        get
        {
            if (Session["summaries"] == null)
                Session["summaries"] = new Dictionary<string, SummaryItemType>();
            return Session["summaries"] as Dictionary<string, SummaryItemType>;
        }
    }
    protected void Page_Init(object sender, EventArgs e)
    {
        if (!IsPostBack)
            Session.Clear();

        RestoreSummaries(ASPxGridView1);
    }
    protected void ASPxGridView1_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
    {
        var grid = sender as ASPxGridView;

        if (e.Parameters.StartsWith("groupFooter"))
        {
            var fieldName = e.Parameters.Split('|')[1];
            var selectedType = e.Parameters.Split('|')[2];
            var summaryType = GetSummaryType(selectedType);
            var key = fieldName + "|" + selectedType;

            if (Summaries.ContainsKey(key))
                Summaries.Remove(key);
            else
                Summaries.Add(key, summaryType);

            if (summaryType == SummaryItemType.None)
            {
                var columnSummaries = Summaries.Where(x => x.Key.StartsWith(fieldName)).ToList();
                foreach (KeyValuePair<string, SummaryItemType> item in columnSummaries)
                {
                    Summaries.Remove(item.Key);
                }
            }

            grid.GroupSummary.Clear();
            RestoreSummaries(grid);
        }
    }
    protected void ASPxGridView1_BeforeGetCallbackResult(object sender, EventArgs e)
    {
        AssignClasses();
    }
    protected void ASPxGridView1_PreRender(object sender, EventArgs e)
    {
        AssignClasses();
    }

    private void RestoreSummaries(ASPxGridView grid)
    {
        foreach (KeyValuePair<string, SummaryItemType> summary in Summaries)
        {
            var fieldName = summary.Key.Split('|')[0];
            grid.GroupSummary.Add(new ASPxSummaryItem(fieldName, summary.Value) { ShowInGroupFooterColumn = fieldName });
        }
    }
    protected SummaryItemType GetSummaryType(string type)
    {
        var summaryType = new SummaryItemType();
        switch (type)
        {
            case "Min":
                summaryType = SummaryItemType.Min;
                break;
            case "Sum":
                summaryType = SummaryItemType.Sum;
                break;
            case "Average":
                summaryType = SummaryItemType.Average;
                break;
            case "Max":
                summaryType = SummaryItemType.Max;
                break;
            case "Count":
                summaryType = SummaryItemType.Count;
                break;
            case "None":
                summaryType = SummaryItemType.None;
                break;
        }
        return summaryType;
    }

    private void AssignClasses()
    {
        foreach (GridViewDataColumn column in ASPxGridView1.Columns)
        {
            column.GroupFooterCellStyle.CssClass = "myFooter|" + column.VisibleIndex + "|";
            var appliedSummaries = Summaries
                .Where(x => x.Key.StartsWith(column.FieldName))
                .Select(x => x.Value.ToString())
                .ToList();
            if (appliedSummaries.Count > 0)
                column.GroupFooterCellStyle.CssClass += String.Join("&", appliedSummaries);
            column.GroupFooterCellStyle.CssClass += "|";
        }
    }
}