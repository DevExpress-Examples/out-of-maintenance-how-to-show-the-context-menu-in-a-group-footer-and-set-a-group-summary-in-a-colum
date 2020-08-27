<%@ Page Language="vb" AutoEventWireup="true" CodeFile="Default.aspx.vb" Inherits="_Default" %>

<%@ Register Assembly="DevExpress.Web.v15.1, Version=15.1.15.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<title></title>
</head>
<body>
	<style type="text/css">
		.checked .imgSrc {
			border: 1px solid #dcdcdc;
			outline: 1px solid #c2c2c2;
			background-color: #dcdcdc;
		}

		.imgSrc {
			background-image: url("Content/Images/DXR.png");
			width: 16px;
			height: 16px;
		}

			.imgSrc.Count {
				background-position: -17px -129px;
			}

			.imgSrc.Min {
				background-position: 0px -95px;
			}

			.imgSrc.Sum {
				background-position: -51px -95px;
			}

			.imgSrc.Max {
				background-position: -34px -78px;
			}

			.imgSrc.Average {
				background-position: -34px -112px;
			}
	</style>
	<script type="text/javascript">

		var columnIndex;
		var appliedSummaries;

		function OnContextMenu(s, e) {
			var target = e.htmlEvent.target;
			var isGroupFooter = target.className.indexOf("myFooter") > -1;
			if (!e.menu && isGroupFooter) {
				columnIndex = target.className.split("|")[1];
				appliedSummaries = target.className.split("|")[2];
				groupFooterMenu.ShowAtPos(ASPxClientUtils.GetEventX(e.htmlEvent), ASPxClientUtils.GetEventY(e.htmlEvent));
			}
		}
		function OnItemClick(s, e) {
			var fieldName = ASPxGridView1.GetColumn(columnIndex).fieldName;
			ASPxGridView1.PerformCallback("groupFooter|" + fieldName + "|" + e.item.name);
			s.Hide();
		}
		function OnPopup(s, e) {
			SetVisibleState(groupFooterMenu);
			SetCheckedState(groupFooterMenu);
			if (appliedSummaries)
				s.GetItemByName("None").SetVisible(true);
		}
		function SetVisibleState(menu) {
			var menuState = ASPxGridView1.GetFooterContextMenu().cpItemsInfo;
			SyncMenuItemsInfoSettings(menu, columnIndex, menuState);
		}
		function SetCheckedState(menu) {
			for (var i = 0; i < menu.GetItemCount() ; i++) {
				var item = menu.GetItem(i);
				var isSummaryApplied = appliedSummaries.indexOf(item.name) > -1;
				if (item.GetVisible()) {
					var element = menu.GetItemElement(item.indexPath);
					isSummaryApplied ?
						element.classList.add("checked") :
						element.classList.remove("checked");
				}
			}
		}
		function SyncMenuItemsInfoSettings(menu, groupElementIndex, itemsInfo) {
			for (var i = 0; i < menu.GetItemCount(); ++i)   {
				var item = menu.GetItem(i);
				var itemInfo = itemsInfo[item.indexPath];
				var visible = false;
				visible = ASPxGridView1.GetItemServerState(itemInfo[0], groupElementIndex);
				item.SetVisible(visible);
			}
		}
	</script>
	<form id="form1" runat="server">
		<div>
			<dx:ASPxGridView ID="ASPxGridView1" runat="server" AutoGenerateColumns="False"
				DataSourceID="AccessDataSource1" KeyFieldName="ProductID"
				ClientInstanceName="ASPxGridView1"
				OnCustomCallback="ASPxGridView1_CustomCallback"
				OnBeforeGetCallbackResult="ASPxGridView1_BeforeGetCallbackResult" 
				OnPreRender="ASPxGridView1_PreRender">
				<SettingsContextMenu Enabled="True">
				</SettingsContextMenu>
				<ClientSideEvents ContextMenu="OnContextMenu" />
				<Settings ShowFooter="True" ShowGroupFooter="VisibleAlways" ShowGroupPanel="True" />
				<Columns>
					<dx:GridViewDataTextColumn FieldName="ProductID" ReadOnly="True" VisibleIndex="0">
						<EditFormSettings Visible="False" />
					</dx:GridViewDataTextColumn>
					<dx:GridViewDataTextColumn FieldName="ProductName" VisibleIndex="1">
					</dx:GridViewDataTextColumn>
					<dx:GridViewDataTextColumn FieldName="UnitPrice" VisibleIndex="2">
					</dx:GridViewDataTextColumn>
					<dx:GridViewDataTextColumn FieldName="UnitsInStock" VisibleIndex="3">
					</dx:GridViewDataTextColumn>
					<dx:GridViewDataTextColumn FieldName="SupplierID" VisibleIndex="4" GroupIndex="0">
					</dx:GridViewDataTextColumn>
				</Columns>
			</dx:ASPxGridView>

			<dx:ASPxPopupMenu ID="ASPxMenu1" runat="server" ClientInstanceName="groupFooterMenu">
				<Items>
					<dx:MenuItem Name="Sum" Text="Sum">
						<Image>
							<SpriteProperties CssClass="imgSrc Sum" />
						</Image>
					</dx:MenuItem>
					<dx:MenuItem Name="Min" Text="Min">
						<Image>
							<SpriteProperties CssClass="imgSrc Min" />
						</Image>
					</dx:MenuItem>
					<dx:MenuItem Name="Max" Text="Max">
						<Image>
							<SpriteProperties CssClass="imgSrc Max" />
						</Image>
					</dx:MenuItem>
					<dx:MenuItem Name="Count" Text="Count">
						<Image>
							<SpriteProperties CssClass="imgSrc Count" />
						</Image>
					</dx:MenuItem>
					<dx:MenuItem Name="Average" Text="Average">
						<Image>
							<SpriteProperties CssClass="imgSrc Average" />
						</Image>
					</dx:MenuItem>
					<dx:MenuItem Name="None" BeginGroup="true" ClientVisible="false" Text="None"></dx:MenuItem>
				</Items>
				<ClientSideEvents ItemClick="OnItemClick" PopUp="OnPopup" />
			</dx:ASPxPopupMenu>
			<asp:AccessDataSource ID="AccessDataSource1" runat="server" DataFile="~/App_Data/nwind.mdb"
				SelectCommand="SELECT [ProductID], [ProductName], [UnitPrice], [UnitsInStock], [SupplierID] FROM [Products]"
				DeleteCommand="DELETE FROM [Products] WHERE [ProductID] = ?"
				InsertCommand="INSERT INTO [Products] ([ProductID], [ProductName], [UnitPrice], [UnitsInStock], [SupplierID]) VALUES (?, ?, ?, ?, ?)"
				UpdateCommand="UPDATE [Products] SET [ProductName] = ?, [UnitPrice] = ?, [UnitsInStock] = ?, [SupplierID] = ? WHERE [ProductID] = ?">
				<DeleteParameters>
					<asp:Parameter Name="ProductID" Type="Int32" />
				</DeleteParameters>
				<InsertParameters>
					<asp:Parameter Name="ProductID" Type="Int32" />
					<asp:Parameter Name="ProductName" Type="String" />
					<asp:Parameter Name="UnitPrice" Type="Decimal" />
					<asp:Parameter Name="UnitsInStock" Type="Int16" />
					<asp:Parameter Name="SupplierID" Type="Int32" />
				</InsertParameters>
				<UpdateParameters>
					<asp:Parameter Name="ProductName" Type="String" />
					<asp:Parameter Name="UnitPrice" Type="Decimal" />
					<asp:Parameter Name="UnitsInStock" Type="Int16" />
					<asp:Parameter Name="SupplierID" Type="Int32" />
					<asp:Parameter Name="ProductID" Type="Int32" />
				</UpdateParameters>
			</asp:AccessDataSource>
		</div>
	</form>
</body>
</html>