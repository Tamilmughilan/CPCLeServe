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
    public class cpcl_lop_day_wiseController : ControllerBase
    {
        private readonly ApidbContext _context;

        public cpcl_lop_day_wiseController(ApidbContext context)
        {
            _context = context;
        }

        // GET: api/cpcl_lop_day_wise
        [HttpGet]
        public async Task<ActionResult<IEnumerable<cpcl_lop_day_wise>>> Getcpcl_lop_day_wise()
        {
            return await _context.cpcl_lop_day_wise.ToListAsync();
        }

        // Update the route for GetLopDetails method
        [HttpGet("prNo/{prNo}")]
        public async Task<ActionResult<IEnumerable<cpcl_lop_day_wise>>> GetLopDetails(int prNo)
        {
            var lopDetails = await _context.cpcl_lop_day_wise
                .Where(l => l.pr_no == prNo)
                .ToListAsync();

            if (lopDetails == null)
            {
                return NotFound();
            }

            return lopDetails;
        }


        // GET: api/cpcl_lop_day_wise/5
        [HttpGet("{id}")]
        public async Task<ActionResult<cpcl_lop_day_wise>> Getcpcl_lop_day_wise(int id)
        {
            var cpcl_lop_day_wise = await _context.cpcl_lop_day_wise.FindAsync(id);

            if (cpcl_lop_day_wise == null)
            {
                return NotFound();
            }

            return cpcl_lop_day_wise;
        }

        // PUT: api/cpcl_lop_day_wise/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> Putcpcl_lop_day_wise(int id, cpcl_lop_day_wise cpcl_lop_day_wise)
        {
            if (id != cpcl_lop_day_wise.employeeId)
            {
                return BadRequest();
            }

            _context.Entry(cpcl_lop_day_wise).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!cpcl_lop_day_wiseExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/cpcl_lop_day_wise
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<cpcl_lop_day_wise>> Postcpcl_lop_day_wise(cpcl_lop_day_wise cpcl_lop_day_wise)
        {
            _context.cpcl_lop_day_wise.Add(cpcl_lop_day_wise);
            await _context.SaveChangesAsync();

            return CreatedAtAction("Getcpcl_lop_day_wise", new { id = cpcl_lop_day_wise.employeeId }, cpcl_lop_day_wise);
        }

        // DELETE: api/cpcl_lop_day_wise/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> Deletecpcl_lop_day_wise(int id)
        {
            var cpcl_lop_day_wise = await _context.cpcl_lop_day_wise.FindAsync(id);
            if (cpcl_lop_day_wise == null)
            {
                return NotFound();
            }

            _context.cpcl_lop_day_wise.Remove(cpcl_lop_day_wise);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool cpcl_lop_day_wiseExists(int id)
        {
            return _context.cpcl_lop_day_wise.Any(e => e.employeeId == id);
        }
    }
}
