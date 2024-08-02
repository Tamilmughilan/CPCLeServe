using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using cpclapp.Models;
using Microsoft.EntityFrameworkCore;

[Route("api/[controller]")]
[ApiController]
public class NotificationsController : ControllerBase
{
    private readonly ApidbContext _context;

    public NotificationsController(ApidbContext context)
    {
        _context = context;
    }

    private async Task<bool> IsInfoSystemsDepartment(int prNo)
    {
        var employee = await _context.Empview.FirstOrDefaultAsync(e => e.H01_EMP_NUM == prNo);
        return employee != null && employee.C02_Function_Desc == "Information Systems";
    }

    [HttpPost("send")]
    public async Task<IActionResult> SendNotification(int prNo, [FromBody] Notification notification)
    {
        if (!await IsInfoSystemsDepartment(prNo))
        {
            return Forbid("You are not authorized to send notifications.");
        }

        _context.Notifications.Add(notification);
        await _context.SaveChangesAsync();

        return Ok(notification);
    }

    [HttpGet("all")]
    public async Task<IActionResult> GetAllNotifications()
    {
        var notifications = await _context.Notifications.ToListAsync();
        return Ok(notifications);
    }

    [HttpDelete("delete/{id}")]
    public async Task<IActionResult> DeleteNotification(int prNo, int id)
    {
        if (!await IsInfoSystemsDepartment(prNo))
        {
            return Forbid("You are not authorized to delete notifications.");
        }

        var notification = await _context.Notifications.FindAsync(id);
        if (notification == null)
        {
            return NotFound("Notification not found.");
        }

        _context.Notifications.Remove(notification);
        await _context.SaveChangesAsync();

        return Ok(new { Message = "Notification deleted successfully." });
    }
}
