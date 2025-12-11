# Data Safety Form - Play Console Responses

This document contains the responses needed for the Google Play Console **Data Safety** section. Use this as a reference when filling out the Data Safety form.

---

## Does your app collect or share any of the required user data types?

**Answer**: ✅ **Yes**

---

## Data Collection and Sharing

### 1. Personal Info

#### Email Address
- **Collected**: ✅ Yes
- **Shared with third parties**: ✅ Yes (Firebase/Google)
- **Data usage**:
  - [x] App functionality
  - [x] Account management
  - [ ] Advertising or marketing
  - [ ] Fraud prevention, security, and compliance
  - [x] Personalization
- **User can choose whether this data is collected**: ❌ No (Required for account creation)
- **Data transfer encryption**: ✅ Yes (TLS/HTTPS)
- **User can request data deletion**: ✅ Yes

#### Name
- **Collected**: ✅ Yes (Optional)
- **Shared with third parties**: ✅ Yes (Firebase/Google)
- **Data usage**:
  - [x] App functionality
  - [x] Personalization
- **User can choose whether this data is collected**: ✅ Yes (Optional field)
- **Data transfer encryption**: ✅ Yes
- **User can request data deletion**: ✅ Yes

---

### 2. Health and Fitness

#### Health Info (Contact Lens Prescription)
- **Collected**: ✅ Yes
- **Data includes**:
  - Left eye diopter
  - Right eye diopter
  - Lens brand and model
  - Wearing schedule (daily/2-week/monthly)
  
- **Shared with third parties**: ✅ Yes (Firebase/Google for storage only)
- **Data usage**:
  - [x] App functionality (lens tracking, reminders)
  - [x] Personalization (price alerts for specific prescription)
  - [ ] Advertising or marketing
  - [ ] Health research
- **User can choose whether this data is collected**: ❌ No (Required for core functionality)
- **Data transfer encryption**: ✅ Yes
- **Data stored encrypted**: ✅ Yes (Firebase encryption at rest)
- **User can request data deletion**: ✅ Yes

**Important Note**: Mark this as **sensitive health information**

---

### 3. App Activity

#### App Interactions
- **Collected**: ✅ Yes
- **Examples**: 
  - Features used
  - Button clicks
  - Time spent in app
  - Reminder settings
  
- **Shared with third parties**: ✅ Yes (Firebase Analytics)
- **Data usage**:
  - [x] Analytics
  - [x] App functionality
  - [ ] Advertising or marketing
  - [ ] Fraud prevention
- **User can choose whether this data is collected**: ✅ Yes (via Analytics opt-out)
- **Data transfer encryption**: ✅ Yes
- **User can request data deletion**: ✅ Yes

#### Crash Logs
- **Collected**: ✅ Yes
- **Shared with third parties**: ✅ Yes (Firebase Crashlytics)
- **Data usage**:
  - [x] Analytics
  - [x] App functionality (debugging)
- **Ephemeral**: ❌ No (Retained for analysis)
- **Data transfer encryption**: ✅ Yes
- **User can request data deletion**: ❌ No (Aggregated/anonymized)

---

### 4. Device or Other IDs

#### Device ID
- **Collected**: ✅ Yes
- **Examples**: Advertising ID, Android ID, Firebase Installation ID
- **Shared with third parties**: ✅ Yes (Firebase)
- **Data usage**:
  - [x] App functionality
  - [x] Analytics
  - [ ] Advertising
- **User can choose whether this data is collected**: ❌ No (Required for Firebase)
- **Data transfer encryption**: ✅ Yes
- **User can request data deletion**: ✅ Yes

---

## Data Security Practices

### Encryption

**Is all user data encrypted in transit?**  
✅ **Yes** - All data is transmitted using TLS/HTTPS encryption

**Is all user data encrypted at rest?**  
✅ **Yes** - Firestore encrypts data at rest automatically

---

### Data Deletion

**Can users request that their data be deleted?**  
✅ **Yes**

**How can users request deletion?**
- **In-app**: Settings > Account > Delete Account
- **Email**: privacy@lensguard.app
- **Response time**: Within 30 days

**Data deletion URL (optional)**: https://yourdomain.com/delete-account

---

## Data Handling Commitments

 You must commit to the following:

✅ **Your app's user data handling practices follow the Google Play Developer Program Policies**, including the Sensitive App Data Policy.

✅ **You ensure that your app handles user data securely**, including by using modern cryptography when transmitting user data over any network.

✅ **If your app lets users create accounts or otherwise manages user logins**, you provide users with a method to request account/data deletion both from within the app and outside of the app (e.g., via a URL).

✅ **You provide a privacy policy** that, together with any in-app disclosures, comprehensively discloses how your app collects, uses, and shares user data.

---

## Third-Party Data Sharing

### Firebase (Google LLC)

**Service types**:
- [x] Cloud hosting and infrastructure
- [x] Analytics
- [x] Crash reports
- [x] Authentication
- [x] Database/data storage
- [x] Push notifications

**Data shared**:
- Email address
- Name
- Health info (prescription)
- Device IDs
- App activity
- Crash logs

**Purpose**:
- App functionality
- Analytics
- Performance monitoring

**Link to third-party privacy policy**:  
https://firebase.google.com/support/privacy

---

## Data Usage Summary

| Data Type | Collected | Shared | Purpose | Deletable |
|-----------|-----------|--------|---------|-----------|
| Email | Yes | Yes (Firebase) | Account, notifications | Yes |
| Name | Yes | Yes (Firebase) | Personalization | Yes |
| Prescription (Health) | Yes | Yes (Firebase) | Tracking, reminders | Yes |
| App Activity | Yes | Yes (Analytics) | Analytics | Partial |
| Crash Logs | Yes | Yes (Crashlytics) | Debugging | No |
| Device IDs | Yes | Yes (Firebase) | Authentication | Yes |

---

## Important Notes for Play Console Submission

1. **Health Data Sensitivity**: 
   - Select "Yes" when asked if you handle sensitive health data
   - This will require additional scrutiny during review

2. **Privacy Policy Requirement**:
   - You MUST have a publicly accessible privacy policy
   - Add the URL in App content > Privacy policy

3. **Data Deletion**:
   - Test the in-app deletion feature before submission
   - Ensure email requests are monitored and responded to

4. **Transparency**:
   - Be honest and thorough in your responses
   - Under-reporting can lead to app suspension
   - Over-reporting is safer than omitting data collection

5. **Updates**:
   - Update Data Safety form whenever you add new data collection
   - Users will be notified of changes

---

## Checklist Before Submission

- [ ] All data types accurately declared
- [ ] All third-party sharing disclosed
- [ ] Privacy policy URL added and accessible
- [ ] Data deletion feature tested and working
- [ ] In-app data disclosure matches Data Safety form
- [ ] Health data handling properly declared
- [ ] Encryption commitments accurate

---

**Last Updated**: December 10, 2024  
**App Version**: 1.0.0  
**Review Date**: Review annually or when data practices change
