# Generate-Dataset.ps1 - Creates comprehensive youth entrepreneurship dataset
param([int]$NumberOfRecords = 1000)

function Generate-RandomSkills {
    $allSkills = @("Web Development", "Digital Marketing", "Sales", "Financial Management", "Leadership", "Agriculture", "Healthcare", "Education", "Creative Arts", "Supply Chain", "Quality Control", "Business Planning")
    $numSkills = Get-Random -Minimum 2 -Maximum 6
    return $allSkills | Get-Random -Count $numSkills
}

function Generate-BusinessInterests {
    $interests = @("Technology", "Agriculture", "Healthcare", "Education", "Tourism", "Manufacturing", "Retail", "Creative Industries", "Food Processing", "Renewable Energy")
    $numInterests = Get-Random -Minimum 1 -Maximum 4
    return $interests | Get-Random -Count $numInterests
}

function Get-SubIndustry($industry) {
    $subIndustries = @{
        "Technology" = @("Software Development", "E-commerce", "Mobile Apps", "AI/ML", "IT Services")
        "Agriculture" = @("Crop Farming", "Livestock", "Food Processing", "Agri-Tech", "Organic Products")
        "Healthcare" = @("Telemedicine", "Medical Devices", "Health Tech", "Wellness Services")
        "Education" = @("EdTech", "Online Courses", "Skill Development", "Educational Content")
    }
    if ($subIndustries.ContainsKey($industry)) {
        return $subIndustries[$industry] | Get-Random
    }
    return "General"
}

function Generate-Dataset {
    param($count)
    
    $dataset = @{
        users = @()
        businessIdeas = @()
        fundingApplications = @()
        mentorshipMatches = @()
        businessPerformance = @()
    }

    $industries = @("Technology", "Agriculture", "Healthcare", "Education", "Tourism", "Manufacturing", "Retail", "Services")
    $locations = @("Maseru", "Leribe", "Berea", "Mafeteng", "Mohale'"s Hoek", "Quthing", "Qacha'"s Nek", "Butha-Buthe")
    $educationLevels = @("High School", "Diploma", "Bachelor'"s Degree", "Master'"s Degree", "PhD")

    Write-Host "Generating $count records..." -ForegroundColor Yellow

    # Generate Users
    for ($i = 1; $i -le $count; $i++) {
        $dataset.users += @{
            id = $i
            age = Get-Random -Minimum 18 -Maximum 35
            gender = @("Male", "Female") | Get-Random
            education = $educationLevels | Get-Random
            location = $locations | Get-Random
            skills = Generate-RandomSkills
            experienceYears = Get-Random -Minimum 0 -Maximum 10
            businessInterests = Generate-BusinessInterests
            previousBusiness = (Get-Random -Maximum 100) -gt 70
        }
    }

    # Generate Business Ideas
    for ($i = 1; $i -le $count; $i++) {
        $industry = $industries | Get-Random
        $dataset.businessIdeas += @{
            id = $i
            userId = $i
            title = "Business Idea $i - $industry Venture"
            description = "Innovative $industry business solution for Lesotho market"
            industry = $industry
            subIndustry = Get-SubIndustry $industry
            innovationLevel = @("Low", "Medium", "High") | Get-Random
            marketSize = @("Small", "Medium", "Large") | Get-Random
            competitionLevel = @("Low", "Medium", "High") | Get-Random
            requiredFunding = Get-Random -Minimum 10000 -Maximum 200000
            teamSize = Get-Random -Minimum 1 -Maximum 10
            technologyReadiness = Get-Random -Minimum 1 -Maximum 11
            scalability = Get-Random -Minimum 1 -Maximum 11
            socialImpact = Get-Random -Minimum 1 -Maximum 11
            sustainability = Get-Random -Minimum 1 -Maximum 11
        }
    }

    # Generate Funding Applications
    for ($i = 1; $i -le $count; $i++) {
        $status = @("Approved", "Rejected", "Pending", "Partially Approved") | Get-Random
        $fundingType = @("Grant", "Loan", "Equity", "Crowdfunding") | Get-Random
        $requestedAmount = Get-Random -Minimum 5000 -Maximum 150000
        
        $dataset.fundingApplications += @{
            id = $i
            businessId = $i
            fundingType = $fundingType
            amountRequested = $requestedAmount
            amountAwarded = if ($status -eq "Approved") { $requestedAmount } elseif ($status -eq "Partially Approved") { [int]($requestedAmount * 0.6) } else { 0 }
            applicationDate = (Get-Date).AddDays(-(Get-Random -Minimum 1 -Maximum 365)).ToString("yyyy-MM-dd")
            decisionDate = (Get-Date).AddDays(-(Get-Random -Minimum 1 -Maximum 300)).ToString("yyyy-MM-dd")
            status = $status
            repaymentTerms = if ($fundingType -eq "Loan") { "24 months, 5% interest" } else { "Non-repayable" }
            equityOffered = if ($fundingType -eq "Equity") { Get-Random -Minimum 5 -Maximum 30 } else { 0 }
            successProbability = [math]::Round((Get-Random -Minimum 0.3 -Maximum 1.0), 2)
            reviewerScore = [math]::Round((Get-Random -Minimum 5.0 -Maximum 10.0), 1)
            riskAssessment = @("Low", "Medium", "High") | Get-Random
        }
    }

    # Generate Mentorship Matches
    for ($i = 1; $i -le $count; $i++) {
        $expertiseAreas = @("Technology", "Agriculture", "Marketing", "Finance", "Operations", "Strategy") | Get-Random -Count (Get-Random -Minimum 2 -Maximum 5)
        
        $dataset.mentorshipMatches += @{
            id = $i
            youthId = $i
            mentorId = Get-Random -Minimum 100 -Maximum 500
            mentorExpertise = $expertiseAreas
            matchScore = [math]::Round((Get-Random -Minimum 6.0 -Maximum 10.0), 1)
            sessionFrequency = @("Weekly", "Bi-weekly", "Monthly") | Get-Random
            duration = Get-Random -Minimum 3 -Maximum 12
            successRating = [math]::Round((Get-Random -Minimum 3.0 -Maximum 5.0), 1)
            skillsImproved = Generate-RandomSkills
            businessImpact = @("Low", "Medium", "High", "Very High") | Get-Random
        }
    }

    # Generate Business Performance
    for ($i = 1; $i -le $count; $i++) {
        $revenue = Get-Random -Minimum 1000 -Maximum 50000
        $expenses = $revenue * (Get-Random -Minimum 0.6 -Maximum 0.9)
        
        $dataset.businessPerformance += @{
            id = $i
            businessId = $i
            month = Get-Random -Minimum 1 -Maximum 24
            revenue = $revenue
            expenses = $expenses
            profit = $revenue - $expenses
            customerCount = Get-Random -Minimum 5 -Maximum 500
            employeeCount = Get-Random -Minimum 1 -Maximum 20
            marketShare = [math]::Round((Get-Random -Minimum 0.1 -Maximum 5.0), 1)
            growthRate = [math]::Round((Get-Random -Minimum 0.05 -Maximum 0.5), 2)
            challenges = @("Funding", "Market Access", "Skills Gap", "Infrastructure", "Competition") | Get-Random -Count (Get-Random -Minimum 1 -Maximum 4)
            milestones = @("Launch", "First Customer", "Profitability", "Expansion", "Award") | Get-Random -Count (Get-Random -Minimum 1 -Maximum 3)
        }
    }

    return $dataset
}

# Main execution
Write-Host "Starting dataset generation..." -ForegroundColor Green
$dataset = Generate-Dataset -count $NumberOfRecords
$dataset | ConvertTo-Json -Depth 10 | Out-File -FilePath "youth_entrepreneurship_dataset.json" -Encoding UTF8

Write-Host "Dataset generated successfully!" -ForegroundColor Green
Write-Host "Total records created:" -ForegroundColor Cyan
Write-Host "  - Users: $($dataset.users.Count)" -ForegroundColor White
Write-Host "  - Business Ideas: $($dataset.businessIdeas.Count)" -ForegroundColor White
Write-Host "  - Funding Applications: $($dataset.fundingApplications.Count)" -ForegroundColor White
Write-Host "  - Mentorship Matches: $($dataset.mentorshipMatches.Count)" -ForegroundColor White
Write-Host "  - Business Performance: $($dataset.businessPerformance.Count)" -ForegroundColor White
Write-Host "File saved: youth_entrepreneurship_dataset.json" -ForegroundColor Yellow
