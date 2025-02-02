
// validate the login form
using System;
using System.ComponentModel.DataAnnotations;


namespace Client.Models
{
    public class LoginFormModel
    {
        [Required(ErrorMessage = "Email is required")]
        [EmailAddress(ErrorMessage = "Invalid Email Address")]
        [MaxLength(50, ErrorMessage = "Email cannot be more than 50 characters")]
        public string Email { get; set; } = String.Empty;

        [Required(ErrorMessage = "Password is required")]
        [MinLength(6, ErrorMessage = "Password must be at least 6 characters")]
        [MaxLength(50, ErrorMessage = "Password cannot be more than 50 characters")]
        // regular expression to enforce password complexity
        [RegularExpression(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\da-zA-Z]).{6,50}$", ErrorMessage = "Password must contain at least one uppercase letter, one lowercase letter, one digit and one special character")]

        public string Password { get; set; } = String.Empty;

    }
}