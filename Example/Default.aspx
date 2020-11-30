<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server" />
    <telerik:RadCodeBlock runat="server">

        <script type="text/javascript">
        
            function removeCssClass(className, element)
            {
                element.className = element.className.replace(className, "").replace(/^\s+/, '').replace(/\s+$/, '');
            }

            function addCssClass(className, element)
            {
                if(element.className.indexOf(className)<0)
                {
                    element.className = element.className + " " + className;
                }
            }
            function onRowClick(sender, eventArgs)
            {
                var radGrid = sender;
                var index = eventArgs.get_itemIndexHierarchical();
                var dataItem = radGrid.get_masterTableView().get_dataItems()[index];
                var row = dataItem.get_element();
                var checkBox = row.children[0].children[0];
                if (!checkBox.checked)
                {
                    checkBox.checked = true;
                    addCssClass("rgSelectedRow",row);
                }
                else
                {
                    checkBox.checked = false;
                    removeCssClass("rgSelectedRow", row);
                }

                CheckHeaderCheckBoxIfNeeded(radGrid);
            }

            function CheckHeaderCheckBoxIfNeeded(radGrid)
            {
                var checkHeaderCheckBox = true;
                var dataItems = radGrid.get_masterTableView().get_dataItems();
                for (var i = 0; i < dataItems.length; i++)
                {
                    var dataItem = dataItems[i];
                    var row = dataItem.get_element();
                    var ckeckBox = row.children[0].children[0];
                    if (!ckeckBox.checked)
                    {
                        checkHeaderCheckBox = false;
                    }
                }

                SelectCheckBox(checkHeaderCheckBox);
            }

            function setSelectedAfterPostback(rowIDs, rowCount)
            {
                var arrRowIDs = rowIDs.split(",");
                for (var i = 0; i < arrRowIDs.length - 1; i++)
                {
                    var row = document.getElementById(arrRowIDs[i]);
                    var checkBox = row.children[0].children[0];
                    checkBox.checked = true;
                    addCssClass("rgSelectedRow",row);
                }
                if (rowCount == arrRowIDs.length - 1)
                {
                    SelectCheckBox(true);
                }
            }

            function CheckBoxCheckedOnClient(rowID, chechBoxId)
            {
                var row = document.getElementById(rowID);
                var ckeckBox = document.getElementById(chechBoxId);
                if (ckeckBox.checked)
                {
                    addCssClass("rgSelectedRow",row);
                }
                else
                {
                    removeCssClass("rgSelectedRow", row);
                }
                var radGrid = $find("<%= RadGrid1.ClientID %>");
                CheckHeaderCheckBoxIfNeeded(radGrid);
            }

            function SelectCheckBox(isChecked)
            {
                var checkBoxID = document.getElementById("<%= HiddenField.ClientID %>").value;
                var checkBox = document.getElementById(checkBoxID);
                checkBox.checked = isChecked;
            }

            function CheckUnCheckAll(id)
            {
                var sender = document.getElementById(id);
                var grid = $find("<%=RadGrid1.ClientID %>");
                var dataItems = grid.get_masterTableView().get_dataItems();
                for (var i = 0; i < dataItems.length; i++)
                {
                    var dataItem = dataItems[i];
                    var row = dataItem.get_element();
                    var checkBox = row.children[0].children[0];
                    if (sender.checked)
                    {
                        checkBox.checked = true;
                        addCssClass("rgSelectedRow",row);
                    }
                    else
                    {
                        checkBox.checked = false;
                        removeCssClass("rgSelectedRow", row);
                    }
                }
            }
            
        </script>

    </telerik:RadCodeBlock>
</head>
<body>
    <form id="form1" runat="server">
    <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
        <Scripts>
            <%--Needed for JavaScript IntelliSense in VS2010--%>
            <%--For VS2008 replace RadScriptManager with ScriptManager--%>
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />
        </Scripts>
    </telerik:RadScriptManager>

    <script type="text/javascript">
        //Put your Java Script code here.
    </script>

    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="Button1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanel1" />
                    <telerik:AjaxUpdatedControl ControlID="Label1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadGrid1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>
    <div>
        <telerik:RadAjaxLoadingPanel runat="server" Skin="Outlook" ID="RadAjaxLoadingPanel1">
        </telerik:RadAjaxLoadingPanel>
        <telerik:RadGrid runat="server" Skin="Outlook" AllowSorting="true" AllowPaging="true"
            AllowFilteringByColumn="true" AutoGenerateColumns="false" PageSize="6" ID="RadGrid1">
            <MasterTableView DataKeyNames="ID">
                <Columns>
                    <telerik:GridTemplateColumn AllowFiltering="false" UniqueName="template">
                        <ItemTemplate>
                            <asp:CheckBox ID="CheckBox1" runat="server" />
                        </ItemTemplate>
                        <HeaderTemplate>
                            <asp:CheckBox ID="CheckBoxHeader" runat="server" />
                        </HeaderTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridBoundColumn DataField="ID" UniqueName="ID" HeaderText="ID">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Item" AllowSorting="false" UniqueName="Item"
                        HeaderText="Item">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Date" UniqueName="Date" HeaderText="Date">
                    </telerik:GridBoundColumn>
                </Columns>
            </MasterTableView>
            <ClientSettings>
                <ClientEvents OnRowClick="onRowClick" />
            </ClientSettings>
        </telerik:RadGrid>
        <asp:HiddenField ID="HiddenField" runat="server" />
          <asp:Label runat="server" ID="Label1"></asp:Label> <br />
        <asp:Button runat="server" ID="Button11" Text="Get all selected IDs for the current page" /><br />
        <asp:Button runat="server" ID="Button2" Text="Navigate to another page and get all selected IDs for all pages" />
        <br />
        <asp:Button runat="server" Text="Check all 10000 items" ID="Button1" />
        
    </div>
    </form>
</body>
</html>
