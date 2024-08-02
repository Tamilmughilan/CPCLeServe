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
    public class cpcl_telephoneController : ControllerBase
    {
        private readonly ApidbContext _context;

        public cpcl_telephoneController(ApidbContext context)
        {
            _context = context;
        }

        // GET: api/cpcl_telephone
        [HttpGet]
        public async Task<ActionResult<IEnumerable<cpcl_telephone>>> GetCpclTelephones()
        {
            try
            {
                var telephoneDirectory = await _context.cpcl_Telephones.ToListAsync();
                return Ok(telephoneDirectory);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, $"Error retrieving data from the database: {ex.Message}");
            }
        }


        // GET: api/cpcl_telephone/5
        [HttpGet("{id}")]
        public async Task<ActionResult<cpcl_telephone>> Getcpcl_telephone(int id)
        {
            var cpcl_telephone = await _context.cpcl_Telephones.FindAsync(id);

            if (cpcl_telephone == null)
            {
                return NotFound();
            }

            return cpcl_telephone;
        }

        // PUT: api/cpcl_telephone/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> Putcpcl_telephone(int id, cpcl_telephone cpcl_telephone)
        {
            if (id != cpcl_telephone.employeeId)
            {
                return BadRequest();
            }

            _context.Entry(cpcl_telephone).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!cpcl_telephoneExists(id))
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

        // POST: api/cpcl_telephone
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<cpcl_telephone>> Postcpcl_telephone(cpcl_telephone cpcl_telephone)
        {
            _context.cpcl_Telephones.Add(cpcl_telephone);
            await _context.SaveChangesAsync();

            return CreatedAtAction("Getcpcl_telephone", new { id = cpcl_telephone.employeeId }, cpcl_telephone);
        }

        // DELETE: api/cpcl_telephone/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> Deletecpcl_telephone(int id)
        {
            var cpcl_telephone = await _context.cpcl_Telephones.FindAsync(id);
            if (cpcl_telephone == null)
            {
                return NotFound();
            }

            _context.cpcl_Telephones.Remove(cpcl_telephone);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool cpcl_telephoneExists(int id)
        {
            return _context.cpcl_Telephones.Any(e => e.employeeId == id);
        }
    }
}
