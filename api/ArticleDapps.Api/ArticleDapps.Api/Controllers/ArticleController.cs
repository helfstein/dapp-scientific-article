using Microsoft.AspNetCore.Mvc;

namespace ArticleDapps.Api.Controllers {

    [Route("api/[controller]")]
    [ApiController]
    public class ArticleController : ControllerBase {
        
        [HttpPost]
        public JsonResult Post(Article artice) {
            var result = new {
                accepted = false
            };
            if (!string.IsNullOrWhiteSpace(artice.ISSN) && artice.ISSN.Length > 3) {
                result = new {
                    accepted = true
                };
            }

            return new JsonResult(result);
        }

    }

}