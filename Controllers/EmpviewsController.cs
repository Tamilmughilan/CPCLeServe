using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using cpclapp.Models;

namespace cpclapp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmpviewsController : ControllerBase
    {
        private readonly ApidbContext _context;

        public EmpviewsController(ApidbContext context)
        {
            _context = context;
        }

        // GET: api/Empviews
        // GET: api/Empviews
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Empview>>> GetEmpviews()
        {
            return await _context.Empview
                                 .Include(e => e.Telephone)
                                 .ToListAsync();
        }


        // GET: api/Empviews/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Empview>> GetEmpview(int id)
        {
            var empview = await _context.Empview.FindAsync(id);

            if (empview == null)
            {
                return NotFound(new { Message = "Employee not found" });
            }

            return empview;
        }

        [HttpGet("bymobile/{mobileNumber}")]
        public async Task<ActionResult<IEnumerable<Empview>>> GetEmployeesByMobile(long mobileNumber)
        {
            var employees = await _context.Empview
                                          .Include(e => e.Telephone)
                                          .Where(e => e.Telephone.Mobile_no == mobileNumber)
                                          .ToListAsync();

            if (employees == null || employees.Count == 0)
            {
                return NotFound(new { Message = "No employees found with this mobile number" });
            }

            return Ok(employees); // Explicitly returning 200 OK with employees data
        }


        [HttpPut("{id}")]
        public async Task<IActionResult> PutEmpview(int id, Empview empview)
        {
            if (id != empview.employeeId)
            {
                return BadRequest(new { Message = "ID mismatch" });
            }

            _context.Entry(empview).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!EmpviewExists(id))
                {
                    return NotFound(new { Message = "Employee not found" });
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        [HttpPost]
        public async Task<ActionResult<Empview>> PostEmpview(Empview empview)
        {
            _context.Empview.Add(empview);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetEmpview), new { id = empview.employeeId }, empview);
        }

        [HttpGet("byprno/{prNo}")]
        public async Task<ActionResult<Empview>> GetEmployeeByPrNo(int prNo)
        {
            var employee = await _context.Empview
                                         .Include(e => e.Telephone)
                                         .SingleOrDefaultAsync(e => e.H01_EMP_NUM == prNo);

            if (employee == null)
            {
                return NotFound(new { Message = "Employee not found with this prNo" });
            }

            return employee;
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteEmpview(int id)
        {
            var empview = await _context.Empview.FindAsync(id);
            if (empview == null)
            {
                return NotFound(new { Message = "Employee not found" });
            }

            _context.Empview.Remove(empview);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool EmpviewExists(int id)
        {
            return _context.Empview.Any(e => e.employeeId == id);
        }
    }
}
