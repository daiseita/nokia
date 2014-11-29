<%@ WebHandler Language="C#" Class="Handler" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
public class Handler : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {

        foreach (string s in context.Request.Files)
        {
            HttpPostedFile file = context.Request.Files[s];

            int fileSizeInBytes = file.ContentLength;
            string fileName = context.Request.Headers["X-File-Name"];
            string fileExtension = "";

            if (!string.IsNullOrEmpty(fileName))
                fileExtension = Path.GetExtension(fileName);

            // IMPORTANT! Make sure to validate uploaded file contents, size, etc. to prevent scripts being uploaded into your web app directory
            string savedFileName = Path.Combine(@"C:\Users\admin\Desktop\Material\upload\local\type01\", Guid.NewGuid().ToString() + fileExtension);
            file.SaveAs(savedFileName);
        }
        
       
    }
    public bool IsReusable {
        get {
            return false;
        }
    }

}

public class ViewDataUploadFilesResult
{
    public string Thumbnail_url { get; set; }
    public string Name { get; set; }
    public int Length { get; set; }
    public string Type { get; set; }
}