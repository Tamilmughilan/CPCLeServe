using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using cpclapp.Models;
using Microsoft.EntityFrameworkCore;

[Route("api/[controller]")]
[ApiController]
public class CircularsController : ControllerBase
{
    private readonly ApidbContext _context;
    private readonly string _circularsDirectory = Path.Combine(Directory.GetCurrentDirectory(), "Circulars");

    public CircularsController(ApidbContext context)
    {
        _context = context;
        if (!Directory.Exists(_circularsDirectory))
        {
            Directory.CreateDirectory(_circularsDirectory);
        }
    }

    private async Task<bool> IsInfoSystemsDepartment(int prNo)
    {
        var employee = await _context.Empview.FirstOrDefaultAsync(e => e.H01_EMP_NUM == prNo);
        return employee != null && employee.C02_Function_Desc == "Information Systems";
    }

    [HttpPost("upload")]
    public async Task<IActionResult> UploadCircular(int prNo, IFormFile file)
    {
        if (file == null || file.Length == 0)
        {
            return BadRequest("No file uploaded.");
        }

        if (!await IsInfoSystemsDepartment(prNo))
        {
            return Forbid("You are not authorized to upload files.");
        }

        var filePath = Path.Combine(_circularsDirectory, file.FileName);

        using (var stream = new FileStream(filePath, FileMode.Create))
        {
            await file.CopyToAsync(stream);
        }

        return Ok(new { FilePath = filePath });
    }

    [HttpGet("download/{fileName}")]
    public IActionResult DownloadCircular(string fileName)
    {
        var filePath = Path.Combine(_circularsDirectory, fileName);

        if (!System.IO.File.Exists(filePath))
        {
            return NotFound();
        }

        var fileBytes = System.IO.File.ReadAllBytes(filePath);
        return File(fileBytes, "application/pdf", fileName);
    }

    [HttpGet("all")]
    public IActionResult GetAllCirculars()
    {
        var files = Directory.GetFiles(_circularsDirectory);
        var fileNames = Array.ConvertAll(files, Path.GetFileName);
        return Ok(fileNames);
    }

    [HttpDelete("delete/{fileName}")]
    public async Task<IActionResult> DeleteCircular(int prNo, string fileName)
    {
        if (!await IsInfoSystemsDepartment(prNo))
        {
            return Forbid("You are not authorized to delete files.");
        }

        var filePath = Path.Combine(_circularsDirectory, fileName);

        if (!System.IO.File.Exists(filePath))
        {
            return NotFound("File not found.");
        }

        System.IO.File.Delete(filePath);

        return Ok(new { Message = "File deleted successfully." });
    }
}
