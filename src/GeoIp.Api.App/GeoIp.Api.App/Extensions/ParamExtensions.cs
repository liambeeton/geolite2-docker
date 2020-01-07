using System.Collections.Generic;

namespace GeoIp.Api.App.Extensions
{
    public static class ParamExtensions
    {
        public static string ReplaceParam(this string content, string param, string value)
        {
            return ReplaceParams(content, new Dictionary<string, string>() { { param, value } });
        }

        public static string ReplaceParams(this string content, IDictionary<string, string> values)
        {
            foreach (string key in values.Keys)
            {
                string paramName = $"{{{{ param_{key} }}}}";
                while (content.IndexOf(paramName) > -1)
                {
                    content = content.Replace(paramName, values[key]);
                }
            }

            return content;
        }
    }
}