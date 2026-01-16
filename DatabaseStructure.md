## FIREBASE FIRESTORE STRUCTURE

### Collections Needed:

1. company_followers
   - id (auto)
   - companyId (string)
   - studentId (string)
   - followedAt (timestamp)
   - status (active/inactive)
   - notifications (boolean)
   - lastEngaged (timestamp)
   - tags (array)

2. company_chat_messages
   - id (auto)
   - companyId (string)
   - studentId (string)
   - message (string)
   - sender (company/student)
   - timestamp (timestamp)
   - read (boolean)
   - attachments (array)
   - type (text/image/file)

3. company_video_interviews
   - id (auto)
   - companyId (string)
   - candidateId (string)
   - jobId (string)
   - scheduledTime (timestamp)
   - duration (number)
   - status (scheduled/completed/cancelled)
   - meetingLink (string)
   - recordingUrl (string)
   - aiAnalysis (object)
   - feedback (object)

4. company_ai_matches
   - id (auto)
   - companyId (string)
   - candidateId (string)
   - jobId (string)
   - matchScore (number)
   - skillsMatch (array)
   - cultureFit (number)
   - predictedSuccess (number)
   - generatedAt (timestamp)
   - status (pending/reviewed/shortlisted)

5. company_branding_assets
   - id (auto)
   - companyId (string)
   - type (logo/cover/video/image)
   - url (string)
   - uploadedAt (timestamp)
   - isPublic (boolean)
   - tags (array)

### Security Rules:

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Company followers - only company can read/write their own followers
    match /company_followers/{document} {
      allow read, write: if request.auth != null && 
        (request.auth.uid == resource.data.companyId || 
         request.auth.uid == resource.data.studentId);
    }
    
    // Chat messages - only participants can read/write
    match /company_chat_messages/{document} {
      allow read, write: if request.auth != null && 
        (request.auth.uid == resource.data.companyId || 
         request.auth.uid == resource.data.studentId);
    }
    
    // Company-specific documents
    match /{collection}/{document} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.companyId;
    }
  }
}
