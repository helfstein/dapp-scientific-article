using System;
using System.IO;
using System.Text;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;

namespace ArticleDapps.Api.Controllers {

    [Route("api/[controller]")]
    [ApiController]
    public class ArticleController : ControllerBase {

        [HttpGet]
        public JsonResult Get() {
            Console.WriteLine("Get Received");
            return new JsonResult(new {accepted = false});
        }

        [HttpPost]
        public IActionResult Post(Article artice) {
            Console.WriteLine("Post Received");
            var result = new {
                data = new {
                    accepted = true,
                    issn = artice.ISSN
                }
            };
            if (!string.IsNullOrWhiteSpace(artice.ISSN) && artice.ISSN.Length > 3) {
                result = new {
                    data = new {
                        accepted = true,
                        issn = artice.ISSN
                    }
                };
            }

            return new JsonResult(result);
            //var json = JsonConvert.SerializeObject(result);


            //var arrJson = Encoding.UTF8.GetBytes(json);
            //return JsonResult(arrJson, "application/json; charset=utf-8");

        }

    }

}