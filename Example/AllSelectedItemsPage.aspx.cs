using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AllSelectedItemsPage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Write("The grid selected rows' IDs<br/>");
        Dictionary<string, bool> dict = Session["SelectedItems"] as Dictionary<string, bool>;
        if (dict != null)
        {
            foreach (KeyValuePair<string, bool> item in dict)
            {
                Response.Write(item.Key + "<br/>");
            }
        }
    }
}
