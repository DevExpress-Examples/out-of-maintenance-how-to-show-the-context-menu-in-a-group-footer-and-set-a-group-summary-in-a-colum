<!-- default badges list -->
![](https://img.shields.io/endpoint?url=https://codecentral.devexpress.com/api/v1/VersionRange/128542945/15.1.9%2B)
[![](https://img.shields.io/badge/Open_in_DevExpress_Support_Center-FF7200?style=flat-square&logo=DevExpress&logoColor=white)](https://supportcenter.devexpress.com/ticket/details/T328939)
[![](https://img.shields.io/badge/📖_How_to_use_DevExpress_Examples-e9f6fc?style=flat-square)](https://docs.devexpress.com/GeneralInformation/403183)
<!-- default badges end -->
<!-- default file list -->
*Files to look at*:

* **[Default.aspx](./CS/Default.aspx) (VB: [Default.aspx](./VB/Default.aspx))**
* [Default.aspx.cs](./CS/Default.aspx.cs) (VB: [Default.aspx.vb](./VB/Default.aspx.vb))
<!-- default file list end -->
# How to show the Context Menu in a group footer and set a group summary in a column
<!-- run online -->
**[[Run Online]](https://codecentral.devexpress.com/t328939/)**
<!-- run online end -->


<p><strong>Starting with version 16.1 we have implemented the built-in context menu for the group footer.</strong><br><br><br><strong>You can use this example for older versions.</strong><br><br>It illustrates how to show the context menu in a group footer and set a group summary in a column.<br><br>To implement a custom Context Menu in a group footer, it is necessary to use <a href="https://documentation.devexpress.com/#AspNet/clsDevExpressWebASPxPopupMenutopic">ASPxPopupMenu</a> and fill its items like in <a href="https://documentation.devexpress.com/#AspNet/CustomDocument17183/gridCM">the Context Menu of a grid’s footer</a>.<br>For this, get the clicked column's index and applied summaries to show the menu's checked items. Then, get item visibility of the <a href="https://documentation.devexpress.com/#AspNet/CustomDocument17183/gridCM">Context Menu in the grid's footer</a> and apply it to the custom Context Menu items.<br>To show the Context Menu in ASPxGridView, enable <a href="https://documentation.devexpress.com/#AspNet/DevExpressWebASPxGridViewContextMenuSettings_Enabledtopic">ASPxGridView's ContextMenu setting</a>.<br><br>To get the clicked column's index and applied summaries, handle ASPxGridView’s PreRender and <a href="https://documentation.devexpress.com/#AspNet/DevExpressWebASPxGridView_BeforeGetCallbackResulttopic">BeforeGetCallBackResult</a> events, build and send a custom class name to the client side by using the GridViewDataColumn.GroupFooterCellStyle.CssClass property. This property includes a custom class name that contains an index and applied summaries of the clicked column. Handle <a href="https://documentation.devexpress.com/#AspNet/DevExpressWebScriptsASPxClientGridView_ContextMenutopic">ASPxGridView's client-side ContextMenu event</a> to get the CssClass name by using htmlEvent’s target.classname property. After the custom class name is obtained, show a popup menu under the mouse pointer.<br>After that, handle <a href="https://documentation.devexpress.com/#AspNet/DevExpressWebScriptsASPxClientMenuBase_PopUptopic">ASPxClientPopupMenu's client-side PopUp</a> event. Set the visibility and a checked state of menu items.<br><br>To set a checked state of a menu item, use applied summaries that were obtained earlier. <br>To set the visibility of menu items like in the menu of the grid’s footer, do the following

* Use the private ASPxClientGridView.GetFooterContextMenu method to get footer menu item information;
* Iterate through all menu items;
* Use the private ASPxClientGridView.GetItemServerState method to get a footer menu item's visibility and apply it to a custom menu item of the group footer. <br><br>Handle <a href="https://documentation.devexpress.com/#AspNet/DevExpressWebScriptsASPxClientMenuBase_ItemClicktopic">ASPxClientPopupMenu's client-side ItemClick</a> event and send an ASPxGridView callback with a column’s field name where the menu is shown and a clicked item name as parameters. Handle <a href="https://documentation.devexpress.com/#AspNet/DevExpressWebASPxGridView_CustomCallbacktopic">ASPxGridView's CustomCallBack</a> event, parse these parameters there and apply the summaries.<br><br><strong>Note:</strong> The private ASPxClientGridView.GetFooterContextMenu and ASPxClientGridView.GetItemServerState methods are used internally. Thus, they can be deleted or modified at any time without notification. It is necessary to check an application where this approach is used on every update of DevExpress controls until the functionality to create summary in the group footer is implemented out of the box.</p>

<br/>


