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
    public class PasstablesController : ControllerBase
    {
        private readonly ApidbContext _context;

        public PasstablesController(ApidbContext context)
        {
            _context = context;
        }

        // GET: api/Passtables
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Passtable>>> GetPasstables()
        {
            return await _context.Passtables.ToListAsync();
        }

        // GET: api/Passtables/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Passtable>> GetPasstable(int id)
        {
            var passtable = await _context.Passtables.FindAsync(id);

            if (passtable == null)
            {
                return NotFound(new { Message = "Password entry not found" });
            }

            return passtable;
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> PutPasstable(int id, Passtable passtable)
        {
            if (id != passtable.employeeId)
            {
                return BadRequest(new { Message = "ID mismatch" });
            }

            _context.Entry(passtable).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!PasstableExists(id))
                {
                    return NotFound(new { Message = "Password entry not found" });
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        [HttpPost]
        public async Task<ActionResult<Passtable>> PostPasstable(Passtable passtable)
        {
            // Add password hashing here
            _context.Passtables.Add(passtable);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetPasstable), new { id = passtable.employeeId }, passtable);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletePasstable(int id)
        {
            var passtable = await _context.Passtables.FindAsync(id);
            if (passtable == null)
            {
                return NotFound(new { Message = "Password entry not found" });
            }

            _context.Passtables.Remove(passtable);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool PasstableExists(int id)
        {
            return _context.Passtables.Any(e => e.employeeId == id);
        }
    }
}
