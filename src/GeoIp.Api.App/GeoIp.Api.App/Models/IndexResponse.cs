namespace GeoIp.Api.App.Models
{
    /// <summary>
    /// Class representing a poll response or version check for the API.
    /// </summary>
    public class IndexResponse
    {
        /// <summary>
        /// Name of the entrypoint API assembly
        /// </summary>
        public string Assembly { get; set; }
        /// <summary>
        /// The configured environment
        /// </summary>
        public string Environment { get; set; }
        /// <summary>
        /// Name of the API
        /// </summary>
        public string Name { get; set; }
        /// <summary>
        /// Version of the API
        /// </summary>
        public string Version { get; set; }
        /// <summary>
        /// Developer/Owner of the API
        /// </summary>
        public string Company { get; set; }
        /// <summary>
        /// Copyright information of the API
        /// </summary>
        public string Copyright { get; set; }
    }
}