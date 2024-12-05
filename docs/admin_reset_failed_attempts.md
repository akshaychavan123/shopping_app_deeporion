## Admin Reset Failed Attempt Alert

### Purpose
To monitor and alert the admin when there are multiple failed password reset attempts in the admin panel (e.g., 3 failed attempts within an hour).

### Workflow
1. A user attempts to reset the admin password.
2. If the email is invalid, the system increments the **failed login attempt counter** in **Rails cache**.
3. If the number of failed attempts exceeds **3** within **1 hour**, an alert email is sent to the admin.
4. Each failed attempt is logged with the email used and the attempt count.

### Key Components
- **Rails Cache**: Stores the number of failed attempts with the key `failed_admin_login_attempts`, which expires after 1 hour.
- **Logging**: Each failed attempt is logged with the email and the updated attempt count.
- **Alert Email**: If 3 failed attempts are made, an email is sent to the admin with the email address and attempt details.

### Configuration
- **Threshold**: 3 failed attempts within 1 hour.
- **Cache Expiry**: 1 hour (`expires_in: 1.hour`).
