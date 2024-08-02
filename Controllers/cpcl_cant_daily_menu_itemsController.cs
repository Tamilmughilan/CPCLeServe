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
    public class cpcl_cant_daily_menu_itemsController : ControllerBase
    {
        private readonly ApidbContext _context;

        public cpcl_cant_daily_menu_itemsController(ApidbContext context)
        {
            _context = context;
        }

        // GET: api/cpcl_cant_daily_menu_items
        [HttpGet]
        public async Task<ActionResult<IEnumerable<cpcl_cant_daily_menu_items>>> GetMenuItems([FromQuery] string dayOfWeek)
        {
            if (!Enum.TryParse(dayOfWeek, true, out DayOfWeek day))
            {
                return BadRequest("Invalid day of the week.");
            }

            // Get the dates corresponding to the specified day of the week for the current week
            var currentDate = DateTime.Today;
            var currentDayOfWeek = (int)currentDate.DayOfWeek;
            var targetDayOfWeek = (int)day;

            var dates = new List<DateTime>();

            for (int i = -7; i <= 7; i++)
            {
                var date = currentDate.AddDays(i);
                if ((int)date.DayOfWeek == targetDayOfWeek)
                {
                    dates.Add(date);
                }
            }

            var menuItems = await _context.cpcl_cant_daily_menu_items
                .Where(m => dates.Select(d => d.Date).Contains(m.CDATE.Date))
                .ToListAsync();

            if (menuItems == null || menuItems.Count == 0)
            {
                return NotFound();
            }

            return Ok(menuItems);
        }

        // GET: api/cpcl_cant_daily_menu_items/5
        [HttpGet("{id}")]
        public async Task<ActionResult<cpcl_cant_daily_menu_items>> Getcpcl_cant_daily_menu_items(int id)
        {
            var cpcl_cant_daily_menu_items = await _context.cpcl_cant_daily_menu_items.FindAsync(id);

            if (cpcl_cant_daily_menu_items == null)
            {
                return NotFound();
            }

            return cpcl_cant_daily_menu_items;
        }

        // PUT: api/cpcl_cant_daily_menu_items/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> Putcpcl_cant_daily_menu_items(int id, cpcl_cant_daily_menu_items cpcl_cant_daily_menu_items)
        {
            if (id != cpcl_cant_daily_menu_items.employeeId)
            {
                return BadRequest();
            }

            _context.Entry(cpcl_cant_daily_menu_items).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!cpcl_cant_daily_menu_itemsExists(id))
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

        // POST: api/cpcl_cant_daily_menu_items
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<cpcl_cant_daily_menu_items>> Postcpcl_cant_daily_menu_items(cpcl_cant_daily_menu_items cpcl_cant_daily_menu_items)
        {
            _context.cpcl_cant_daily_menu_items.Add(cpcl_cant_daily_menu_items);
            await _context.SaveChangesAsync();

            return CreatedAtAction("Getcpcl_cant_daily_menu_items", new { id = cpcl_cant_daily_menu_items.employeeId }, cpcl_cant_daily_menu_items);
        }

        // DELETE: api/cpcl_cant_daily_menu_items/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> Deletecpcl_cant_daily_menu_items(int id)
        {
            var cpcl_cant_daily_menu_items = await _context.cpcl_cant_daily_menu_items.FindAsync(id);
            if (cpcl_cant_daily_menu_items == null)
            {
                return NotFound();
            }

            _context.cpcl_cant_daily_menu_items.Remove(cpcl_cant_daily_menu_items);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool cpcl_cant_daily_menu_itemsExists(int id)
        {
            return _context.cpcl_cant_daily_menu_items.Any(e => e.employeeId == id);
        }
    }
}
