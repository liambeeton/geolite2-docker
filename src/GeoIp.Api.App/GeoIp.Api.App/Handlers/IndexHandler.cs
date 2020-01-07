using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using GeoIp.Api.App.Extensions;
using GeoIp.Api.App.Models;
using Microsoft.AspNetCore.Http;

namespace GeoIp.Api.App.Handlers
{
    public abstract class IndexHandler : IIndexHandler
    {
        private static readonly Dictionary<string, Type> FactoryTypes = new Dictionary<string, Type>
        {
                { "application/json", typeof(JsonIndex) },
                { "text/plain", typeof(TextPlainIndex) },
                { "text/html", typeof(HtmlIndex) }
        };

        public static IIndexHandler GetInstance(string contentType)
        {
            if (FactoryTypes.ContainsKey(contentType))
            {
                return Activator.CreateInstance(FactoryTypes[contentType]) as IIndexHandler;
            }

            throw new NotImplementedException($"No handler for Content-Type '{ contentType }' defined.");
        }

        protected const string MarkdownContent = @".\wwwroot\index.md";
        protected const string HtmlContent = @".\wwwroot\index.html";
        protected const string CssContent = @"site.css";


        protected readonly AssemblyName AssemblyName;

        protected string Version => AssemblyName.Version.ToString().Substring(0, 5);

        protected IndexHandler()
        {
            AssemblyName = typeof(IndexHandler).Assembly.GetName();
        }

        protected async Task<IndexResponse> GetApiDetails(string environment)
        {
            return await Task.Run(() =>
            {
                var info = FileVersionInfo.GetVersionInfo(typeof(JsonIndex).Assembly.Location);
                return new IndexResponse()
                {
                    Assembly = AssemblyName.FullName,
                    Environment = environment,
                    Name = info.ProductName,
                    Version = Version,
                    Company = info.CompanyName,
                    Copyright = info.LegalCopyright
                };
            });

        }

        protected Dictionary<string, string> GetParamDictionary(IndexResponse details)
        {
            return new Dictionary<string, string>() {
                { "Name", details.Name },
                { "Version", details.Version },
                { "Environment", details.Environment },
                { "Assembly", details.Assembly },
                { "Company", details.Company },
                { "Copyright", details.Copyright }
            };
        }

        #region IIndex

        public abstract Task<object> Get(string environment, HttpContext context);

        #endregion
    }

    internal class JsonIndex : IndexHandler
    {
        public override async Task<object> Get(string environment, HttpContext context)
        {
            return await GetApiDetails(environment);
        }
    }

    internal class TextPlainIndex : IndexHandler
    {
        public override async Task<object> Get(string environment, HttpContext context)
        {
            IndexResponse details = await GetApiDetails(environment);
            return (await File.ReadAllTextAsync(MarkdownContent)).ReplaceParams(GetParamDictionary(details));
        }
    }

    internal class HtmlIndex : IndexHandler
    {
        public override async Task<object> Get(string environment, HttpContext context)
        {
            string html = await File.ReadAllTextAsync(HtmlContent);
            int headIndex = html.IndexOf("</head>", StringComparison.Ordinal);
            html = html.Insert(headIndex, $"<link href=\"{ CssContent }\" rel=\"stylesheet\" />");
            IndexResponse details = await GetApiDetails(environment);
            html = html.ReplaceParams(GetParamDictionary(details));

            byte[] buffer = Encoding.UTF8.GetBytes(html);
            context.Response.Body.Write(buffer, 0, buffer.Length);

            return null;
        }
    }
}