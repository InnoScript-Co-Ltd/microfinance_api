-- CreateEnum
CREATE TYPE "CustomerType" AS ENUM ('INDIVIDUAL', 'BUSINESS', 'GROUP');

-- CreateEnum
CREATE TYPE "Gender" AS ENUM ('MALE', 'FEMALE', 'OTHER', 'PREFER_NOT_TO_SAY');

-- CreateEnum
CREATE TYPE "CustomerStatus" AS ENUM ('PENDING', 'ACTIVE', 'INACTIVE', 'BLOCKED', 'CLOSED');

-- CreateEnum
CREATE TYPE "PhoneOrEmailVerifiedStatus" AS ENUM ('PENDING', 'VERIFIED');

-- CreateEnum
CREATE TYPE "CustomerAuthStatus" AS ENUM ('PENDING', 'ACTIVE', 'LOCKED', 'SUSPENDED', 'DISABLED');

-- CreateEnum
CREATE TYPE "OtpChannel" AS ENUM ('SMS', 'EMAIL');

-- CreateEnum
CREATE TYPE "OtpPurpose" AS ENUM ('REGISTRATION', 'LOGIN', 'VERIFY_PHONE', 'VERIFY_EMAIL', 'RESET_PASSWORD', 'RESET_PIN', 'CHANGE_PHONE', 'CHANGE_EMAIL');

-- CreateEnum
CREATE TYPE "OtpStatus" AS ENUM ('PENDING', 'VERIFIED', 'EXPIRED', 'FAILED');

-- CreateEnum
CREATE TYPE "KycLevel" AS ENUM ('BASIC', 'STANDARD', 'ENHANCED');

-- CreateEnum
CREATE TYPE "KycStatus" AS ENUM ('PENDING', 'VERIFIED', 'REJECTED', 'EXPIRED');

-- CreateEnum
CREATE TYPE "VerificationMethod" AS ENUM ('MANUAL', 'OCR', 'E_KYC', 'BIOMETRIC', 'THIRD_PARTY');

-- CreateEnum
CREATE TYPE "RiskLevel" AS ENUM ('LOW', 'MEDIUM', 'HIGH');

-- CreateEnum
CREATE TYPE "KycDocumentType" AS ENUM ('NATIONAL_ID_FRONT', 'NATIONAL_ID_BACK', 'PASSPORT', 'DRIVING_LICENSE', 'RESIDENCE_PERMIT', 'WORK_PERMIT', 'SELFIE', 'ADDRESS_PROOF', 'INCOME_PROOF', 'BUSINESS_LICENSE', 'OTHER');

-- CreateEnum
CREATE TYPE "DocumentVerificationStatus" AS ENUM ('PENDING', 'VERIFIED', 'REJECTED', 'EXPIRED');

-- CreateEnum
CREATE TYPE "CustomerAddressType" AS ENUM ('CURRENT', 'PERMANENT', 'WORK', 'BUSINESS', 'OTHER');

-- CreateEnum
CREATE TYPE "CustomerContactType" AS ENUM ('EMERGENCY', 'SPOUSE', 'PARENT', 'CHILD', 'SIBLING', 'GUARDIAN', 'RELATIVE', 'FRIEND', 'OTHER');

-- CreateEnum
CREATE TYPE "EmploymentType" AS ENUM ('EMPLOYED', 'SELF_EMPLOYED', 'BUSINESS_OWNER', 'FARMER', 'FISHERMAN', 'DAILY_WORKER', 'STUDENT', 'UNEMPLOYED', 'RETIRED', 'OTHER');

-- CreateEnum
CREATE TYPE "BranchStatus" AS ENUM ('ACTIVE', 'TEMPORY_CLOSE', 'INACTIVE');

-- CreateTable
CREATE TABLE "customers" (
    "id" BIGINT NOT NULL,
    "branchId" BIGINT NOT NULL,
    "customerNo" VARCHAR(30) NOT NULL,
    "customerType" "CustomerType" NOT NULL DEFAULT 'INDIVIDUAL',
    "firstName" VARCHAR(100) NOT NULL,
    "lastName" VARCHAR(100) NOT NULL,
    "profile" VARCHAR(150),
    "gender" "Gender" NOT NULL DEFAULT 'PREFER_NOT_TO_SAY',
    "dateOfBirth" DATE,
    "nationality" VARCHAR(100),
    "maritalStatus" VARCHAR(50),
    "phone" VARCHAR(30) NOT NULL,
    "email" VARCHAR(150) NOT NULL,
    "occupation" VARCHAR(150),
    "status" "CustomerStatus" NOT NULL DEFAULT 'PENDING',
    "registeredAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "customers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "customer_auth" (
    "id" BIGINT NOT NULL,
    "customerId" BIGINT NOT NULL,
    "username" VARCHAR(100),
    "passwordHash" VARCHAR(255),
    "pinHash" VARCHAR(255),
    "phoneVerified" "PhoneOrEmailVerifiedStatus" NOT NULL DEFAULT 'PENDING',
    "phoneVerifiedAt" TIMESTAMP(3),
    "emailVerified" "PhoneOrEmailVerifiedStatus" NOT NULL DEFAULT 'PENDING',
    "emailVerifiedAt" TIMESTAMP(3),
    "twoFactorEnabled" BOOLEAN NOT NULL DEFAULT false,
    "failedLoginAttempts" INTEGER NOT NULL DEFAULT 0,
    "lockedUntil" TIMESTAMP(3),
    "lastLoginAt" TIMESTAMP(3),
    "lastLoginIp" VARCHAR(45),
    "passwordChangedAt" TIMESTAMP(3),
    "pinChangedAt" TIMESTAMP(3),
    "status" "CustomerAuthStatus" NOT NULL DEFAULT 'PENDING',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "customer_auth_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "customer_otps" (
    "id" BIGINT NOT NULL,
    "customerId" BIGINT,
    "channel" "OtpChannel" NOT NULL,
    "prupose" "OtpPurpose" NOT NULL,
    "destination" VARCHAR(255) NOT NULL,
    "codeHash" VARCHAR(255) NOT NULL,
    "status" "OtpStatus" NOT NULL DEFAULT 'PENDING',
    "attempts" INTEGER NOT NULL DEFAULT 0,
    "maxAttempts" INTEGER NOT NULL DEFAULT 5,
    "expiredAt" TIMESTAMP(3) NOT NULL,
    "verifiedAt" TIMESTAMP(3),
    "ipAddress" VARCHAR(45),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "customer_otps_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "customer_sessions" (
    "id" BIGINT NOT NULL,
    "customerId" BIGINT NOT NULL,
    "refreshTokenHash" VARCHAR(255) NOT NULL,
    "deviceId" VARCHAR(255),
    "deviceName" VARCHAR(255),
    "ipAddress" VARCHAR(45),
    "userAgent" VARCHAR(500),
    "expiredAt" TIMESTAMP(3) NOT NULL,
    "revokedAt" TIMESTAMP(3),
    "lastUserAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "customer_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "customer_kycs" (
    "id" BIGINT NOT NULL,
    "customerId" BIGINT NOT NULL,
    "kycLevel" "KycLevel" NOT NULL DEFAULT 'BASIC',
    "status" "KycStatus" NOT NULL DEFAULT 'PENDING',
    "verificationMethod" "VerificationMethod",
    "nationalId" VARCHAR(100),
    "passportNo" VARCHAR(100),
    "idIssuedDate" DATE,
    "idExpiryDate" DATE,
    "idIssuedCountry" VARCHAR(100),
    "submittedAt" TIMESTAMP(3),
    "reviewedAt" TIMESTAMP(3),
    "verifiedAt" TIMESTAMP(3),
    "verifiedBy" BIGINT,
    "rejectionReason" TEXT,
    "reviewNote" TEXT,
    "riskLevel" "RiskLevel" NOT NULL DEFAULT 'LOW',
    "isPep" BOOLEAN NOT NULL DEFAULT false,
    "isSanctioned" BOOLEAN NOT NULL DEFAULT false,
    "isBlacklisted" BOOLEAN NOT NULL DEFAULT false,
    "riskScore" DECIMAL(8,2),
    "dataConsent" BOOLEAN NOT NULL DEFAULT false,
    "marketingConsent" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "customer_kycs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "customer_documents" (
    "id" BIGINT NOT NULL,
    "customerId" BIGINT NOT NULL,
    "kycId" BIGINT,
    "documentType" "KycDocumentType" NOT NULL,
    "documentNumber" VARCHAR(100),
    "fileName" VARCHAR(255),
    "fileKey" VARCHAR(500) NOT NULL,
    "mimeType" VARCHAR(100),
    "fileSize" BIGINT,
    "issuedDate" DATE,
    "expiryDate" DATE,
    "issuedCountry" VARCHAR(100),
    "verificationStatus" "DocumentVerificationStatus" NOT NULL DEFAULT 'PENDING',
    "verifiedAt" TIMESTAMP(3),
    "verifiedBy" BIGINT,
    "rejectionReason" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "customer_documents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "customer_addresses" (
    "id" BIGINT NOT NULL,
    "customerId" BIGINT NOT NULL,
    "addressType" "CustomerAddressType" NOT NULL,
    "addressLine1" VARCHAR(255) NOT NULL,
    "addressLine2" VARCHAR(255),
    "houseNo" VARCHAR(50),
    "street" VARCHAR(150),
    "village" VARCHAR(150),
    "ward" VARCHAR(150),
    "township" VARCHAR(150),
    "district" VARCHAR(150),
    "region" VARCHAR(150),
    "city" VARCHAR(150),
    "state" VARCHAR(150),
    "country" VARCHAR(150) NOT NULL,
    "postalCode" VARCHAR(150),
    "latitude" DECIMAL(10,7),
    "longitude" DECIMAL(10,7),
    "isPrimary" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "customer_addresses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "customer_contacts" (
    "id" BIGINT NOT NULL,
    "customerId" BIGINT NOT NULL,
    "contactType" "CustomerContactType" NOT NULL,
    "name" VARCHAR(150) NOT NULL,
    "relationship" VARCHAR(100),
    "phone" VARCHAR(30),
    "alternatePhone" VARCHAR(30),
    "email" VARCHAR(255),
    "address" VARCHAR(500),
    "isPrimary" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "customer_contacts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "customer_employments" (
    "id" BIGINT NOT NULL,
    "customerId" BIGINT NOT NULL,
    "employmentType" "EmploymentType" NOT NULL,
    "employerName" VARCHAR(200),
    "jobTitle" VARCHAR(150),
    "businessName" VARCHAR(200),
    "businessType" VARCHAR(150),
    "businessAddress" VARCHAR(500),
    "yearExperience" DECIMAL(5,2),
    "monthlyIncome" DECIMAL(18,2),
    "monthlyExpenses" DECIMAL(18,2),
    "incomeSource" VARCHAR(200),
    "employerPhone" VARCHAR(30),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "customer_employments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "branches" (
    "id" BIGINT NOT NULL,
    "branchCode" VARCHAR(30) NOT NULL,
    "name" VARCHAR(150) NOT NULL,
    "phone" VARCHAR(30),
    "address" TEXT,
    "latitude" DECIMAL(10,7),
    "longitude" DECIMAL(10,7),
    "country" VARCHAR(100) NOT NULL,
    "region" VARCHAR(150),
    "distruct" VARCHAR(150),
    "city" VARCHAR(150),
    "township" VARCHAR(150),
    "postalCode" VARCHAR(20),
    "status" "BranchStatus" NOT NULL DEFAULT 'ACTIVE',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "branches_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "customers_customerNo_key" ON "customers"("customerNo");

-- CreateIndex
CREATE UNIQUE INDEX "customers_phone_key" ON "customers"("phone");

-- CreateIndex
CREATE UNIQUE INDEX "customers_email_key" ON "customers"("email");

-- CreateIndex
CREATE INDEX "customers_customerNo_idx" ON "customers"("customerNo");

-- CreateIndex
CREATE INDEX "customers_phone_idx" ON "customers"("phone");

-- CreateIndex
CREATE INDEX "customers_email_idx" ON "customers"("email");

-- CreateIndex
CREATE INDEX "customers_status_idx" ON "customers"("status");

-- CreateIndex
CREATE INDEX "customers_branchId_idx" ON "customers"("branchId");

-- CreateIndex
CREATE UNIQUE INDEX "customer_auth_customerId_key" ON "customer_auth"("customerId");

-- CreateIndex
CREATE UNIQUE INDEX "customer_auth_username_key" ON "customer_auth"("username");

-- CreateIndex
CREATE INDEX "customer_auth_status_idx" ON "customer_auth"("status");

-- CreateIndex
CREATE INDEX "customer_otps_customerId_idx" ON "customer_otps"("customerId");

-- CreateIndex
CREATE INDEX "customer_otps_destination_idx" ON "customer_otps"("destination");

-- CreateIndex
CREATE INDEX "customer_otps_prupose_idx" ON "customer_otps"("prupose");

-- CreateIndex
CREATE INDEX "customer_otps_status_idx" ON "customer_otps"("status");

-- CreateIndex
CREATE INDEX "customer_otps_expiredAt_idx" ON "customer_otps"("expiredAt");

-- CreateIndex
CREATE INDEX "customer_sessions_customerId_idx" ON "customer_sessions"("customerId");

-- CreateIndex
CREATE INDEX "customer_sessions_expiredAt_idx" ON "customer_sessions"("expiredAt");

-- CreateIndex
CREATE INDEX "customer_sessions_revokedAt_idx" ON "customer_sessions"("revokedAt");

-- CreateIndex
CREATE UNIQUE INDEX "customer_kycs_customerId_key" ON "customer_kycs"("customerId");

-- CreateIndex
CREATE INDEX "customer_kycs_status_idx" ON "customer_kycs"("status");

-- CreateIndex
CREATE INDEX "customer_kycs_kycLevel_idx" ON "customer_kycs"("kycLevel");

-- CreateIndex
CREATE INDEX "customer_kycs_nationalId_idx" ON "customer_kycs"("nationalId");

-- CreateIndex
CREATE INDEX "customer_kycs_passportNo_idx" ON "customer_kycs"("passportNo");

-- CreateIndex
CREATE INDEX "customer_kycs_riskLevel_idx" ON "customer_kycs"("riskLevel");

-- CreateIndex
CREATE INDEX "customer_kycs_isPep_idx" ON "customer_kycs"("isPep");

-- CreateIndex
CREATE INDEX "customer_kycs_isSanctioned_idx" ON "customer_kycs"("isSanctioned");

-- CreateIndex
CREATE INDEX "customer_documents_customerId_idx" ON "customer_documents"("customerId");

-- CreateIndex
CREATE INDEX "customer_documents_kycId_idx" ON "customer_documents"("kycId");

-- CreateIndex
CREATE INDEX "customer_documents_documentType_idx" ON "customer_documents"("documentType");

-- CreateIndex
CREATE INDEX "customer_documents_verificationStatus_idx" ON "customer_documents"("verificationStatus");

-- CreateIndex
CREATE INDEX "customer_addresses_customerId_idx" ON "customer_addresses"("customerId");

-- CreateIndex
CREATE INDEX "customer_addresses_addressType_idx" ON "customer_addresses"("addressType");

-- CreateIndex
CREATE INDEX "customer_addresses_township_idx" ON "customer_addresses"("township");

-- CreateIndex
CREATE INDEX "customer_addresses_district_idx" ON "customer_addresses"("district");

-- CreateIndex
CREATE INDEX "customer_addresses_region_idx" ON "customer_addresses"("region");

-- CreateIndex
CREATE INDEX "customer_addresses_country_idx" ON "customer_addresses"("country");

-- CreateIndex
CREATE INDEX "customer_contacts_customerId_idx" ON "customer_contacts"("customerId");

-- CreateIndex
CREATE INDEX "customer_contacts_contactType_idx" ON "customer_contacts"("contactType");

-- CreateIndex
CREATE INDEX "customer_contacts_phone_idx" ON "customer_contacts"("phone");

-- CreateIndex
CREATE UNIQUE INDEX "customer_employments_customerId_key" ON "customer_employments"("customerId");

-- CreateIndex
CREATE INDEX "customer_employments_employmentType_idx" ON "customer_employments"("employmentType");

-- CreateIndex
CREATE UNIQUE INDEX "branches_branchCode_key" ON "branches"("branchCode");

-- CreateIndex
CREATE INDEX "branches_branchCode_idx" ON "branches"("branchCode");

-- CreateIndex
CREATE INDEX "branches_status_idx" ON "branches"("status");

-- CreateIndex
CREATE INDEX "branches_country_idx" ON "branches"("country");

-- CreateIndex
CREATE INDEX "branches_region_idx" ON "branches"("region");

-- CreateIndex
CREATE INDEX "branches_distruct_idx" ON "branches"("distruct");

-- CreateIndex
CREATE INDEX "branches_city_idx" ON "branches"("city");

-- CreateIndex
CREATE INDEX "branches_township_idx" ON "branches"("township");

-- AddForeignKey
ALTER TABLE "customers" ADD CONSTRAINT "customers_branchId_fkey" FOREIGN KEY ("branchId") REFERENCES "branches"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "customer_auth" ADD CONSTRAINT "customer_auth_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "customers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "customer_otps" ADD CONSTRAINT "customer_otps_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "customers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "customer_sessions" ADD CONSTRAINT "customer_sessions_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "customers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "customer_kycs" ADD CONSTRAINT "customer_kycs_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "customers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "customer_documents" ADD CONSTRAINT "customer_documents_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "customers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "customer_documents" ADD CONSTRAINT "customer_documents_kycId_fkey" FOREIGN KEY ("kycId") REFERENCES "customer_kycs"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "customer_addresses" ADD CONSTRAINT "customer_addresses_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "customers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "customer_contacts" ADD CONSTRAINT "customer_contacts_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "customers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "customer_employments" ADD CONSTRAINT "customer_employments_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "customers"("id") ON DELETE CASCADE ON UPDATE CASCADE;
