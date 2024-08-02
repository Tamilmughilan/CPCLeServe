using Microsoft.AspNetCore.Mvc;
using System.Linq;
using System.Threading.Tasks;
using cpclapp.Models;
using Microsoft.EntityFrameworkCore;

namespace cpclapp.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class LoginController : ControllerBase
    {
        private readonly ApidbContext _context;

        public LoginController(ApidbContext context)
        {
            _context = context;
        }

        [HttpPost]
        public async Task<IActionResult> Login([FromBody] LoginRequest loginRequest)
        {
            if (loginRequest == null)
            {
                return BadRequest(new { Message = "Invalid request" });
            }

            var employee = await _context.Empview
                .FirstOrDefaultAsync(e => e.H01_EMP_NUM == loginRequest.prNo);

            if (employee == null)
            {
                return NotFound(new { Message = "PR Number not found" });
            }

            var passwordEntry = await _context.Passtables
                .FirstOrDefaultAsync(p => p.prno == loginRequest.prNo);

            if (passwordEntry == null)
            {
                return Unauthorized(new { Message = "Password entry not found" });
            }

            if (passwordEntry.password != loginRequest.password)
            {
                return Unauthorized(new { Message = "Invalid password" });
            }

            // Generate a token or session here (JWT token recommended)

            return Ok(new { Message = "Login successful", employee.employeeId });
        }
    }

    public class LoginRequest
    {
        public int prNo { get; set; }
        public string password { get; set; }
    }
}
