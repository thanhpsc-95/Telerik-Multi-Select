using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Data;
using System.Configuration;
using System.Web.Security;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Telerik.Web.UI;
using System.Collections.Generic;
using System.Text;

public partial class Default : System.Web.UI.Page
{
    public Dictionary<string, bool> SelectedItems
    {
        get
        {
            if (Session["SelectedItems"] == null)
            {
                Session["SelectedItems"] = new Dictionary<string, bool>();
            }

            return Session["SelectedItems"] as Dictionary<string, bool>;
        }
        set
        {
            Session["SelectedItems"] = value;
        }
    }

    protected override void OnInit(EventArgs e)
    {
        base.OnInit(e);

        RadGrid1.NeedDataSource += new GridNeedDataSourceEventHandler(RadGrid1_NeedDataSource);
        RadGrid1.ItemDataBound += new GridItemEventHandler(RadGrid1_ItemDataBound);
        RadGrid1.PreRender += new EventHandler(RadGrid1_PreRender);
        RadGrid1.ItemCreated += new GridItemEventHandler(RadGrid1_ItemCreated);
        RadGrid1.ItemCommand += new GridCommandEventHandler(RadGrid1_ItemCommand);
        Button2.Click += new EventHandler(Button2_Click);
        Button1.Click += new EventHandler(Button1_Click);
    }

    void Button1_Click(object sender, EventArgs e)
    {
        RadGrid1.AllowPaging = false;
        RadGrid1.Rebind();
        foreach (var item in RadGrid1.Items)
        {
            ((item as GridDataItem)["template"].FindControl("CheckBox1") as CheckBox).Checked = true;
        }
        SaveSelectedItems();
        RadGrid1.AllowPaging = true;
        RadGrid1.Rebind();
    }

    void RadGrid1_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        DataTable table = new DataTable();
        table.Columns.Add("ID", typeof(Int32));
        table.Columns.Add("Item");
        table.Columns.Add("Date", typeof(DateTime));
        for (int i = 1; i < 10001; i++)
        {
            table.Rows.Add(i, "Item" + i.ToString(), DateTime.Now.AddDays(i));
        }
        RadGrid1.DataSource = table;
    }

    void RadGrid1_ItemCreated(object sender, GridItemEventArgs e)
    {
        if (e.Item.ItemType == GridItemType.Header)
        {
            GridHeaderItem headerItem = (GridHeaderItem)e.Item;
            CheckBox chkSelectAll = (CheckBox)headerItem["template"].Controls[1];
            HiddenField.Value = chkSelectAll.ClientID;

            string script = "CheckUnCheckAll('" + chkSelectAll.ClientID + "')";
            chkSelectAll.Attributes.Add("onclick", script);
        } 
    }

    void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            GridDataItem item = e.Item as GridDataItem;
            CheckBox checkBox = item["template"].FindControl("CheckBox1") as CheckBox;
            string id = item["ID"].Text;
            if (SelectedItems.ContainsKey(id))
            {
                checkBox.Checked = Convert.ToBoolean(SelectedItems[id].ToString());
            }
            string script = "CheckBoxCheckedOnClient('" + item.ClientID + "', '" + checkBox.ClientID + "')";
            checkBox.Attributes.Add("onclick", script);
        }
    }


    void RadGrid1_ItemCommand(object source, GridCommandEventArgs e)
    {
         SaveSelectedItems();
    }

    void RadGrid1_PreRender(object sender, EventArgs e)
    {
        string IDs = string.Empty;
        string rowIDs = string.Empty;
        foreach (GridDataItem item in RadGrid1.MasterTableView.Items)
        {
            CheckBox checkBox = item["template"].FindControl("CheckBox1") as CheckBox;
            if (checkBox.Checked)
            {
                IDs = IDs + item["ID"].Text + ",";
                rowIDs = rowIDs + item.ClientID.ToString() + ",";
            }
        }
        if (!string.IsNullOrEmpty(IDs))
        {
            IDs = IDs.Substring(0, IDs.LastIndexOf(","));
            int rowCount = RadGrid1.PageSize;
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "setSelectedAfterPostback", "setSelectedAfterPostback('" + rowIDs + "', " + rowCount + ");", true);
            Label1.Text = IDs;
        }
    }

    private void SaveSelectedItems()
    {
        foreach (GridItem item in RadGrid1.Items)
        {
            if (item is GridDataItem)
            {
                GridDataItem dataItem = item as GridDataItem;
                if ((dataItem["template"].FindControl("CheckBox1") as CheckBox).Checked)
                {
                    if (!SelectedItems.ContainsKey(dataItem["ID"].Text))
                    {
                        SelectedItems.Add(dataItem["ID"].Text, true);
                    }
                }
                else
                {
                    if (SelectedItems.ContainsKey(dataItem["ID"].Text))
                    {
                        SelectedItems.Remove(dataItem["ID"].Text);
                    }
                }
            }
        }
    }

    void Button2_Click(object sender, EventArgs e)
    {
        SaveSelectedItems();
        RadAjaxManager1.Redirect("~/AllSelectedItemsPage.aspx");
    }
}
