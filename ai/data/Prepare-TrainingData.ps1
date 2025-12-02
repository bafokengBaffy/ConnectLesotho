# Prepare-TrainingData.ps1 - Prepares ML training data from the dataset
param([string]$DatasetPath = "youth_entrepreneurship_dataset.json")

function Import-Dataset {
    param($path)
    if (-not (Test-Path $path)) {
        Write-Error "Dataset file not found: $path"
        exit 1
    }
    $jsonContent = Get-Content -Path $path -Raw
    return $jsonContent | ConvertFrom-Json
}

function Prepare-SuccessPredictionData {
    param($dataset)
    $trainingData = @()
    foreach ($business in $dataset.businessIdeas) {
        $performance = $dataset.businessPerformance | Where-Object { $_.businessId -eq $business.id } | Select-Object -First 1
        $funding = $dataset.fundingApplications | Where-Object { $_.businessId -eq $business.id } | Select-Object -First 1
        $user = $dataset.users | Where-Object { $_.id -eq $business.userId } | Select-Object -First 1
        
        $isSuccessful = if ($performance) { 
            if ($performance.profit -gt 0 -and $performance.growthRate -gt 0.1) { 1 } else { 0 }
        } else { 0 }
        
        $trainingData += @{
            features = @{
                innovationLevel = switch ($business.innovationLevel) { "Low" { 1 } "Medium" { 2 } "High" { 3 } default { 2 } }
                marketSize = switch ($business.marketSize) { "Small" { 1 } "Medium" { 2 } "Large" { 3 } default { 2 } }
                competitionLevel = switch ($business.competitionLevel) { "Low" { 1 } "Medium" { 2 } "High" { 3 } default { 2 } }
                teamSize = $business.teamSize
                technologyReadiness = $business.technologyReadiness
                scalability = $business.scalability
                fundingAmount = if ($funding) { $funding.amountAwarded } else { 0 }
                experienceYears = $user.experienceYears
                socialImpact = $business.socialImpact
                sustainability = $business.sustainability
            }
            label = $isSuccessful
            businessId = $business.id
        }
    }
    return $trainingData
}

function Prepare-FundingRecommendationData {
    param($dataset)
    $trainingData = @()
    foreach ($application in $dataset.fundingApplications) {
        $business = $dataset.businessIdeas | Where-Object { $_.id -eq $application.businessId } | Select-Object -First 1
        $user = $dataset.users | Where-Object { $_.id -eq $business.userId } | Select-Object -First 1
        $performance = $dataset.businessPerformance | Where-Object { $_.businessId -eq $business.id } | Select-Object -First 1
        
        $trainingData += @{
            features = @{
                requestedAmount = $application.amountRequested
                businessAge = if ($performance) { $performance.month } else { 0 }
                revenue = if ($performance) { $performance.revenue } else { 0 }
                profit = if ($performance) { $performance.profit } else { 0 }
                teamSize = $business.teamSize
                experienceYears = $user.experienceYears
                innovationLevel = switch ($business.innovationLevel) { "Low" { 1 } "Medium" { 2 } "High" { 3 } default { 2 } }
                socialImpact = $business.socialImpact
                riskAssessment = switch ($application.riskAssessment) { "Low" { 1 } "Medium" { 2 } "High" { 3 } default { 2 } }
            }
            label = if ($application.status -eq "Approved" -or $application.status -eq "Partially Approved") { 1 } else { 0 }
            fundingType = $application.fundingType
            applicationId = $application.id
        }
    }
    return $trainingData
}

function Prepare-MentorMatchingData {
    param($dataset)
    $trainingData = @()
    foreach ($match in $dataset.mentorshipMatches) {
        $youth = $dataset.users | Where-Object { $_.id -eq $match.youthId } | Select-Object -First 1
        $business = $dataset.businessIdeas | Where-Object { $_.userId -eq $match.youthId } | Select-Object -First 1
        
        $trainingData += @{
            youthProfile = @{
                skills = $youth.skills
                businessInterests = $youth.businessInterests
                education = $youth.education
                experienceYears = $youth.experienceYears
                location = $youth.location
            }
            mentorExpertise = $match.mentorExpertise
            matchScore = $match.matchScore
            successRating = $match.successRating
            businessIndustry = $business.industry
        }
    }
    return $trainingData
}

# Main execution
Write-Host "Loading dataset..." -ForegroundColor Yellow
$dataset = Import-Dataset -path $DatasetPath

Write-Host "Preparing training data..." -ForegroundColor Yellow
$successPredictionData = Prepare-SuccessPredictionData -dataset $dataset
$fundingRecommendationData = Prepare-FundingRecommendationData -dataset $dataset
$mentorMatchingData = Prepare-MentorMatchingData -dataset $dataset

$trainingData = @{
    successPrediction = @{
        training = $successPredictionData[0..799]
        test = $successPredictionData[800..999]
    }
    fundingRecommendation = @{
        training = $fundingRecommendationData[0..799]
        test = $fundingRecommendationData[800..999]
    }
    mentorMatching = @{
        training = $mentorMatchingData[0..799]
        test = $mentorMatchingData[800..999]
    }
    metadata = @{
        totalRecords = $dataset.businessIdeas.Count
        generatedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        datasetVersion = "1.0"
    }
}

$trainingData | ConvertTo-Json -Depth 10 | Out-File -FilePath "training_data.json" -Encoding UTF8

Write-Host "Training data prepared successfully!" -ForegroundColor Green
Write-Host "Data splits:" -ForegroundColor Cyan
Write-Host "  - Success Prediction: $($trainingData.successPrediction.training.Count) training, $($trainingData.successPrediction.test.Count) test" -ForegroundColor White
Write-Host "  - Funding Recommendation: $($trainingData.fundingRecommendation.training.Count) training, $($trainingData.fundingRecommendation.test.Count) test" -ForegroundColor White
Write-Host "  - Mentor Matching: $($trainingData.mentorMatching.training.Count) training, $($trainingData.mentorMatching.test.Count) test" -ForegroundColor White
Write-Host "File saved: training_data.json" -ForegroundColor Yellow
