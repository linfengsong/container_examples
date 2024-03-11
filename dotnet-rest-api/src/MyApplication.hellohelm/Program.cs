



using Serilog;
using System.Net;

var builder = WebApplication.CreateBuilder(args);

builder.Host.UseSerilog((ctx, config) =>
{
    config.ReadFrom.Configuration(ctx.Configuration);
});

// Add services to the container.
builder.Services.AddControllers();

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// required to stop Example proxy intercepting and blocking localhost
var webProxy = new WebProxy
{
    BypassProxyOnLocal = true,
};
builder.Services.AddHttpClient("--InsertClientNameHere--", client =>
{
    client.BaseAddress = new Uri("--InsertServiceUriHere--");
})
.ConfigurePrimaryHttpMessageHandler(() => new HttpClientHandler()
{
    Proxy = webProxy,
});


var app = builder.Build();

// Configure the HTTP request pipeline.
//if (app.Environment.IsDevelopment())
//{
    app.UseSwagger();
    app.UseSwaggerUI();
//}

app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

app.Run();