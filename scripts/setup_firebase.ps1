# Creates the LensGuard Firebase project via the user's authenticated gcloud,
# wires the real config into the app, and rebuilds the release AAB.
# Run from the repo root:  powershell -ExecutionPolicy Bypass -File scripts\setup_firebase.ps1

$ErrorActionPreference = 'Stop'
$ProjectId = 'lensguard-app-2026'
$Package = 'com.lensguard.app'
$Sha1 = 'BA23CD6B7AE892FF0978988F7C6F31A6990FBF35'
$Flutter = "C:\Users\ameri\Downloads\flutter\bin\flutter.bat"

function Invoke-FirebaseApi($Method, $Uri, $Body) {
    $token = gcloud auth print-access-token
    $headers = @{ Authorization = "Bearer $token"; 'Content-Type' = 'application/json' }
    if ($null -ne $Body) {
        Invoke-RestMethod -Method $Method -Uri $Uri -Headers $headers -Body ($Body | ConvertTo-Json -Depth 5)
    } else {
        Invoke-RestMethod -Method $Method -Uri $Uri -Headers $headers
    }
}

function Wait-Operation($OpName) {
    while ($true) {
        $op = Invoke-FirebaseApi GET "https://firebase.googleapis.com/v1/$OpName" $null
        if ($op.done) { if ($op.error) { throw ($op.error | ConvertTo-Json) }; return $op.response }
        Start-Sleep -Seconds 3
    }
}

Write-Host "== 1/7 GCP-Projekt anlegen =="
$exists = gcloud projects list --filter="projectId=$ProjectId" --format="value(projectId)"
if (-not $exists) { gcloud projects create $ProjectId --name="LensGuard" }

Write-Host "== 2/7 APIs aktivieren =="
gcloud services enable firebase.googleapis.com firestore.googleapis.com identitytoolkit.googleapis.com --project $ProjectId

Write-Host "== 3/7 Firebase hinzufuegen =="
try {
    $op = Invoke-FirebaseApi POST "https://firebase.googleapis.com/v1beta1/projects/${ProjectId}:addFirebase" @{}
    Wait-Operation $op.name | Out-Null
} catch { Write-Host "  (schon vorhanden oder: $_)" }

Write-Host "== 4/7 Android-App registrieren =="
$apps = Invoke-FirebaseApi GET "https://firebase.googleapis.com/v1beta1/projects/$ProjectId/androidApps" $null
$app = $apps.apps | Where-Object { $_.packageName -eq $Package }
if (-not $app) {
    $op = Invoke-FirebaseApi POST "https://firebase.googleapis.com/v1beta1/projects/$ProjectId/androidApps" @{ packageName = $Package; displayName = 'LensGuard' }
    Wait-Operation $op.name | Out-Null
    $apps = Invoke-FirebaseApi GET "https://firebase.googleapis.com/v1beta1/projects/$ProjectId/androidApps" $null
    $app = $apps.apps | Where-Object { $_.packageName -eq $Package }
}
try {
    Invoke-FirebaseApi POST "https://firebase.googleapis.com/v1beta1/$($app.name)/sha" @{ shaHash = $Sha1; certType = 'SHA_1' } | Out-Null
} catch { Write-Host "  (SHA-1 schon hinterlegt)" }

Write-Host "== 5/7 google-services.json holen und firebase_options.dart patchen =="
$cfg = Invoke-FirebaseApi GET "https://firebase.googleapis.com/v1beta1/$($app.name)/config" $null
$json = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($cfg.configFileContents))
Set-Content -Path "android\app\google-services.json" -Value $json -Encoding utf8
$gs = $json | ConvertFrom-Json
$apiKey = $gs.client[0].api_key[0].current_key
$appId = $gs.client[0].client_info.mobilesdk_app_id
$sender = $gs.project_info.project_number
$bucket = if ($gs.project_info.storage_bucket) { $gs.project_info.storage_bucket } else { "$ProjectId.appspot.com" }
$opts = Get-Content "lib\firebase_options.dart" -Raw
$opts = $opts -replace "apiKey: 'YOUR_API_KEY'", "apiKey: '$apiKey'"
$opts = $opts -replace "appId: 'YOUR_APP_ID'", "appId: '$appId'"
$opts = $opts -replace "messagingSenderId: 'YOUR_MESSAGING_SENDER_ID'", "messagingSenderId: '$sender'"
$opts = $opts -replace "projectId: 'YOUR_PROJECT_ID'", "projectId: '$ProjectId'"
$opts = $opts -replace "storageBucket: 'YOUR_STORAGE_BUCKET'", "storageBucket: '$bucket'"
Set-Content -Path "lib\firebase_options.dart" -Value $opts -Encoding utf8
Write-Host "  Hinweis: nur der Android-Block wurde ersetzt; iOS-Platzhalter bleiben."

Write-Host "== 6/7 Auth (E-Mail/Passwort) + Firestore =="
try {
    Invoke-FirebaseApi PATCH "https://identitytoolkit.googleapis.com/admin/v2/projects/$ProjectId/config?updateMask=signIn.email" @{ signIn = @{ email = @{ enabled = $true; passwordRequired = $true } } } | Out-Null
} catch { Write-Host "  Auth-Config: $_ (ggf. einmalig in der Firebase Console unter Authentication aktivieren)" }
$db = gcloud firestore databases list --project $ProjectId --format="value(name)" 2>$null
if (-not $db) { gcloud firestore databases create --location=eur3 --project=$ProjectId }

Write-Host "== 7/7 Release-AAB neu bauen =="
& $Flutter build appbundle --release
Write-Host ""
Write-Host "Fertig. AAB: build\app\outputs\bundle\release\app-release.aab"
Write-Host "Manuell noch noetig: Google Sign-In Provider in der Firebase Console aktivieren (Authentication > Sign-in method > Google)."
