-- CreateEnum
CREATE TYPE "ConcurrencyLimitStrategy" AS ENUM ('CANCEL_IN_PROGRESS', 'DROP_NEWEST', 'QUEUE_NEWEST', 'GROUP_ROUND_ROBIN');

-- CreateEnum
CREATE TYPE "InviteLinkStatus" AS ENUM ('PENDING', 'ACCEPTED', 'REJECTED');

-- CreateEnum
CREATE TYPE "JobKind" AS ENUM ('DEFAULT', 'ON_FAILURE');

-- CreateEnum
CREATE TYPE "JobRunStatus" AS ENUM ('PENDING', 'RUNNING', 'SUCCEEDED', 'FAILED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "LimitResource" AS ENUM ('WORKFLOW_RUN', 'EVENT', 'WORKER', 'CRON', 'SCHEDULE');

-- CreateEnum
CREATE TYPE "LogLineLevel" AS ENUM ('DEBUG', 'INFO', 'WARN', 'ERROR');

-- CreateEnum
CREATE TYPE "StepRunEventReason" AS ENUM ('REQUEUED_NO_WORKER', 'REQUEUED_RATE_LIMIT', 'SCHEDULING_TIMED_OUT', 'ASSIGNED', 'STARTED', 'FINISHED', 'FAILED', 'RETRYING', 'CANCELLED', 'TIMED_OUT', 'REASSIGNED', 'SLOT_RELEASED', 'TIMEOUT_REFRESHED', 'RETRIED_BY_USER', 'SENT_TO_WORKER');

-- CreateEnum
CREATE TYPE "StepRunEventSeverity" AS ENUM ('INFO', 'WARNING', 'CRITICAL');

-- CreateEnum
CREATE TYPE "StepRunStatus" AS ENUM ('PENDING', 'PENDING_ASSIGNMENT', 'ASSIGNED', 'RUNNING', 'SUCCEEDED', 'FAILED', 'CANCELLED', 'CANCELLING');

-- CreateEnum
CREATE TYPE "StickyStrategy" AS ENUM ('SOFT', 'HARD');

-- CreateEnum
CREATE TYPE "TenantMemberRole" AS ENUM ('OWNER', 'ADMIN', 'MEMBER');

-- CreateEnum
CREATE TYPE "TenantResourceLimitAlertType" AS ENUM ('Alarm', 'Exhausted');

-- CreateEnum
CREATE TYPE "VcsProvider" AS ENUM ('GITHUB');

-- CreateEnum
CREATE TYPE "WorkerLabelComparator" AS ENUM ('EQUAL', 'NOT_EQUAL', 'GREATER_THAN', 'GREATER_THAN_OR_EQUAL', 'LESS_THAN', 'LESS_THAN_OR_EQUAL');

-- CreateEnum
CREATE TYPE "WorkflowKind" AS ENUM ('FUNCTION', 'DURABLE', 'DAG');

-- CreateEnum
CREATE TYPE "WorkflowRunStatus" AS ENUM ('PENDING', 'RUNNING', 'SUCCEEDED', 'FAILED', 'QUEUED');

-- CreateTable
CREATE TABLE "APIToken" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" TIMESTAMP(3),
    "revoked" BOOLEAN NOT NULL DEFAULT false,
    "name" TEXT,
    "tenantId" UUID,
    "nextAlertAt" TIMESTAMP(3),
    "internal" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "APIToken_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Action" (
    "description" TEXT,
    "tenantId" UUID NOT NULL,
    "actionId" TEXT NOT NULL,
    "id" UUID NOT NULL,

    CONSTRAINT "Action_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ControllerPartition" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastHeartbeat" TIMESTAMP(3),

    CONSTRAINT "ControllerPartition_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Dispatcher" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "lastHeartbeatAt" TIMESTAMP(3),
    "isActive" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "Dispatcher_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Event" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "key" TEXT NOT NULL,
    "tenantId" UUID NOT NULL,
    "replayedFromId" UUID,
    "data" JSONB,
    "additionalMetadata" JSONB,

    CONSTRAINT "Event_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "GetGroupKeyRun" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "tenantId" UUID NOT NULL,
    "workerId" UUID,
    "tickerId" UUID,
    "status" "StepRunStatus" NOT NULL DEFAULT 'PENDING',
    "input" JSONB,
    "output" TEXT,
    "requeueAfter" TIMESTAMP(3),
    "error" TEXT,
    "startedAt" TIMESTAMP(3),
    "finishedAt" TIMESTAMP(3),
    "timeoutAt" TIMESTAMP(3),
    "cancelledAt" TIMESTAMP(3),
    "cancelledReason" TEXT,
    "cancelledError" TEXT,
    "workflowRunId" UUID NOT NULL,
    "scheduleTimeoutAt" TIMESTAMP(3),

    CONSTRAINT "GetGroupKeyRun_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Job" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "tenantId" UUID NOT NULL,
    "workflowVersionId" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "timeout" TEXT,
    "kind" "JobKind" NOT NULL DEFAULT 'DEFAULT',

    CONSTRAINT "Job_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "JobRun" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "tenantId" UUID NOT NULL,
    "jobId" UUID NOT NULL,
    "tickerId" UUID,
    "status" "JobRunStatus" NOT NULL DEFAULT 'PENDING',
    "result" JSONB,
    "startedAt" TIMESTAMP(3),
    "finishedAt" TIMESTAMP(3),
    "timeoutAt" TIMESTAMP(3),
    "cancelledAt" TIMESTAMP(3),
    "cancelledReason" TEXT,
    "cancelledError" TEXT,
    "workflowRunId" UUID NOT NULL,

    CONSTRAINT "JobRun_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "JobRunLookupData" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "jobRunId" UUID NOT NULL,
    "tenantId" UUID NOT NULL,
    "data" JSONB,

    CONSTRAINT "JobRunLookupData_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LogLine" (
    "id" BIGSERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "tenantId" UUID NOT NULL,
    "stepRunId" UUID,
    "message" TEXT NOT NULL,
    "level" "LogLineLevel" NOT NULL DEFAULT 'INFO',
    "metadata" JSONB,

    CONSTRAINT "LogLine_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Queue" (
    "id" BIGSERIAL NOT NULL,
    "tenantId" UUID NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Queue_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "QueueItem" (
    "id" BIGSERIAL NOT NULL,
    "stepRunId" UUID,
    "stepId" UUID,
    "actionId" TEXT,
    "scheduleTimeoutAt" TIMESTAMP(3),
    "stepTimeout" TEXT,
    "priority" INTEGER NOT NULL DEFAULT 1,
    "isQueued" BOOLEAN NOT NULL,
    "tenantId" UUID NOT NULL,
    "queue" TEXT NOT NULL,
    "sticky" "StickyStrategy",
    "desiredWorkerId" UUID,

    CONSTRAINT "QueueItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RateLimit" (
    "tenantId" UUID NOT NULL,
    "key" TEXT NOT NULL,
    "limitValue" INTEGER NOT NULL,
    "value" INTEGER NOT NULL,
    "window" TEXT NOT NULL,
    "lastRefill" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "SNSIntegration" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "tenantId" UUID NOT NULL,
    "topicArn" TEXT NOT NULL,

    CONSTRAINT "SNSIntegration_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SecurityCheckIdent" (
    "id" UUID NOT NULL,

    CONSTRAINT "SecurityCheckIdent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Service" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "name" TEXT NOT NULL,
    "description" TEXT,
    "tenantId" UUID NOT NULL,

    CONSTRAINT "Service_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SlackAppWebhook" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "tenantId" UUID NOT NULL,
    "teamId" TEXT NOT NULL,
    "teamName" TEXT NOT NULL,
    "channelId" TEXT NOT NULL,
    "channelName" TEXT NOT NULL,
    "webhookURL" BYTEA NOT NULL,

    CONSTRAINT "SlackAppWebhook_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Step" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "readableId" TEXT,
    "tenantId" UUID NOT NULL,
    "jobId" UUID NOT NULL,
    "actionId" TEXT NOT NULL,
    "timeout" TEXT,
    "customUserData" JSONB,
    "retries" INTEGER NOT NULL DEFAULT 0,
    "scheduleTimeout" TEXT NOT NULL DEFAULT '5m',

    CONSTRAINT "Step_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StepDesiredWorkerLabel" (
    "id" BIGSERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "stepId" UUID NOT NULL,
    "key" TEXT NOT NULL,
    "strValue" TEXT,
    "intValue" INTEGER,
    "required" BOOLEAN NOT NULL,
    "comparator" "WorkerLabelComparator" NOT NULL,
    "weight" INTEGER NOT NULL,

    CONSTRAINT "StepDesiredWorkerLabel_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StepRateLimit" (
    "units" INTEGER NOT NULL,
    "stepId" UUID NOT NULL,
    "rateLimitKey" TEXT NOT NULL,
    "tenantId" UUID NOT NULL
);

-- CreateTable
CREATE TABLE "StepRun" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "tenantId" UUID NOT NULL,
    "jobRunId" UUID NOT NULL,
    "stepId" UUID NOT NULL,
    "order" BIGSERIAL NOT NULL,
    "workerId" UUID,
    "tickerId" UUID,
    "status" "StepRunStatus" NOT NULL DEFAULT 'PENDING',
    "input" JSONB,
    "output" JSONB,
    "requeueAfter" TIMESTAMP(3),
    "scheduleTimeoutAt" TIMESTAMP(3),
    "error" TEXT,
    "startedAt" TIMESTAMP(3),
    "finishedAt" TIMESTAMP(3),
    "timeoutAt" TIMESTAMP(3),
    "cancelledAt" TIMESTAMP(3),
    "cancelledReason" TEXT,
    "cancelledError" TEXT,
    "inputSchema" JSONB,
    "callerFiles" JSONB,
    "gitRepoBranch" TEXT,
    "retryCount" INTEGER NOT NULL DEFAULT 0,
    "semaphoreReleased" BOOLEAN NOT NULL DEFAULT false,
    "queue" TEXT NOT NULL DEFAULT 'default',

    CONSTRAINT "StepRun_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StepRunEvent" (
    "id" BIGSERIAL NOT NULL,
    "timeFirstSeen" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "timeLastSeen" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "stepRunId" UUID NOT NULL,
    "reason" "StepRunEventReason" NOT NULL,
    "severity" "StepRunEventSeverity" NOT NULL,
    "message" TEXT NOT NULL,
    "count" INTEGER NOT NULL,
    "data" JSONB
);

-- CreateTable
CREATE TABLE "StepRunResultArchive" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "stepRunId" UUID NOT NULL,
    "order" BIGSERIAL NOT NULL,
    "input" JSONB,
    "output" JSONB,
    "error" TEXT,
    "startedAt" TIMESTAMP(3),
    "finishedAt" TIMESTAMP(3),
    "timeoutAt" TIMESTAMP(3),
    "cancelledAt" TIMESTAMP(3),
    "cancelledReason" TEXT,
    "cancelledError" TEXT,

    CONSTRAINT "StepRunResultArchive_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StreamEvent" (
    "id" BIGSERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "tenantId" UUID NOT NULL,
    "stepRunId" UUID,
    "message" BYTEA NOT NULL,
    "metadata" JSONB,

    CONSTRAINT "StreamEvent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Tenant" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "analyticsOptOut" BOOLEAN NOT NULL DEFAULT false,
    "alertMemberEmails" BOOLEAN NOT NULL DEFAULT true,
    "controllerPartitionId" TEXT,
    "workerPartitionId" TEXT,
    "dataRetentionPeriod" TEXT NOT NULL DEFAULT '720h',

    CONSTRAINT "Tenant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TenantAlertEmailGroup" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "tenantId" UUID NOT NULL,
    "emails" TEXT NOT NULL,

    CONSTRAINT "TenantAlertEmailGroup_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TenantAlertingSettings" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "tenantId" UUID NOT NULL,
    "maxFrequency" TEXT NOT NULL DEFAULT '1h',
    "lastAlertedAt" TIMESTAMP(3),
    "tickerId" UUID,
    "enableExpiringTokenAlerts" BOOLEAN NOT NULL DEFAULT true,
    "enableWorkflowRunFailureAlerts" BOOLEAN NOT NULL DEFAULT false,
    "enableTenantResourceLimitAlerts" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "TenantAlertingSettings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TenantInviteLink" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "tenantId" UUID NOT NULL,
    "inviterEmail" TEXT NOT NULL,
    "inviteeEmail" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL,
    "status" "InviteLinkStatus" NOT NULL DEFAULT 'PENDING',
    "role" "TenantMemberRole" NOT NULL DEFAULT 'OWNER',

    CONSTRAINT "TenantInviteLink_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TenantMember" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "tenantId" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "role" "TenantMemberRole" NOT NULL,

    CONSTRAINT "TenantMember_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TenantResourceLimit" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "resource" "LimitResource" NOT NULL,
    "tenantId" UUID NOT NULL,
    "limitValue" INTEGER NOT NULL,
    "alarmValue" INTEGER,
    "value" INTEGER NOT NULL DEFAULT 0,
    "window" TEXT,
    "lastRefill" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "customValueMeter" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "TenantResourceLimit_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TenantResourceLimitAlert" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "resourceLimitId" UUID NOT NULL,
    "tenantId" UUID NOT NULL,
    "resource" "LimitResource" NOT NULL,
    "alertType" "TenantResourceLimitAlertType" NOT NULL,
    "value" INTEGER NOT NULL,
    "limit" INTEGER NOT NULL,

    CONSTRAINT "TenantResourceLimitAlert_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TenantVcsProvider" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "tenantId" UUID NOT NULL,
    "vcsProvider" "VcsProvider" NOT NULL,
    "config" JSONB,

    CONSTRAINT "TenantVcsProvider_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TenantWorkerPartition" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastHeartbeat" TIMESTAMP(3),

    CONSTRAINT "TenantWorkerPartition_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Ticker" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastHeartbeatAt" TIMESTAMP(3),
    "isActive" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "Ticker_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "User" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "email" TEXT NOT NULL,
    "emailVerified" BOOLEAN NOT NULL DEFAULT false,
    "name" TEXT,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserOAuth" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" UUID NOT NULL,
    "provider" TEXT NOT NULL,
    "providerUserId" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3),
    "accessToken" BYTEA NOT NULL,
    "refreshToken" BYTEA,

    CONSTRAINT "UserOAuth_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserPassword" (
    "hash" TEXT NOT NULL,
    "userId" UUID NOT NULL
);

-- CreateTable
CREATE TABLE "UserSession" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" UUID,
    "data" JSONB,
    "expiresAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "UserSession_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WebhookWorker" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "name" TEXT NOT NULL,
    "secret" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "tokenValue" TEXT,
    "deleted" BOOLEAN NOT NULL DEFAULT false,
    "tokenId" UUID,
    "tenantId" UUID NOT NULL,

    CONSTRAINT "WebhookWorker_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WebhookWorkerWorkflow" (
    "id" UUID NOT NULL,
    "webhookWorkerId" UUID NOT NULL,
    "workflowId" UUID NOT NULL,

    CONSTRAINT "WebhookWorkerWorkflow_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Worker" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "tenantId" UUID NOT NULL,
    "lastHeartbeatAt" TIMESTAMP(3),
    "name" TEXT NOT NULL,
    "dispatcherId" UUID,
    "maxRuns" INTEGER NOT NULL DEFAULT 100,
    "isActive" BOOLEAN NOT NULL DEFAULT false,
    "lastListenerEstablished" TIMESTAMP(3),
    "isPaused" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Worker_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WorkerLabel" (
    "id" BIGSERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "workerId" UUID NOT NULL,
    "key" TEXT NOT NULL,
    "strValue" TEXT,
    "intValue" INTEGER,

    CONSTRAINT "WorkerLabel_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WorkerSemaphore" (
    "workerId" UUID NOT NULL,
    "slots" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "WorkerSemaphoreSlot" (
    "id" UUID NOT NULL,
    "workerId" UUID NOT NULL,
    "stepRunId" UUID,

    CONSTRAINT "WorkerSemaphoreSlot_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Workflow" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "tenantId" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,

    CONSTRAINT "Workflow_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WorkflowConcurrency" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "workflowVersionId" UUID NOT NULL,
    "getConcurrencyGroupId" UUID,
    "maxRuns" INTEGER NOT NULL DEFAULT 1,
    "limitStrategy" "ConcurrencyLimitStrategy" NOT NULL DEFAULT 'CANCEL_IN_PROGRESS',

    CONSTRAINT "WorkflowConcurrency_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WorkflowRun" (
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "tenantId" UUID NOT NULL,
    "workflowVersionId" UUID NOT NULL,
    "status" "WorkflowRunStatus" NOT NULL DEFAULT 'PENDING',
    "error" TEXT,
    "startedAt" TIMESTAMP(3),
    "finishedAt" TIMESTAMP(3),
    "concurrencyGroupId" TEXT,
    "displayName" TEXT,
    "id" UUID NOT NULL,
    "childIndex" INTEGER,
    "childKey" TEXT,
    "parentId" UUID,
    "parentStepRunId" UUID,
    "additionalMetadata" JSONB,
    "duration" INTEGER,

    CONSTRAINT "WorkflowRun_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WorkflowRunDedupe" (
    "id" BIGSERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "tenantId" UUID NOT NULL,
    "workflowId" UUID NOT NULL,
    "workflowRunId" UUID NOT NULL,
    "value" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "WorkflowRunStickyState" (
    "id" BIGSERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "tenantId" UUID NOT NULL,
    "workflowRunId" UUID NOT NULL,
    "desiredWorkerId" UUID,
    "strategy" "StickyStrategy" NOT NULL,

    CONSTRAINT "WorkflowRunStickyState_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WorkflowRunTriggeredBy" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "tenantId" UUID NOT NULL,
    "eventId" UUID,
    "cronParentId" UUID,
    "cronSchedule" TEXT,
    "scheduledId" UUID,
    "input" JSONB,
    "parentId" UUID NOT NULL,

    CONSTRAINT "WorkflowRunTriggeredBy_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WorkflowTag" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "tenantId" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "color" TEXT NOT NULL DEFAULT '#93C5FD',

    CONSTRAINT "WorkflowTag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WorkflowTriggerCronRef" (
    "parentId" UUID NOT NULL,
    "cron" TEXT NOT NULL,
    "tickerId" UUID,
    "input" JSONB,
    "enabled" BOOLEAN NOT NULL DEFAULT true
);

-- CreateTable
CREATE TABLE "WorkflowTriggerEventRef" (
    "parentId" UUID NOT NULL,
    "eventKey" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "WorkflowTriggerScheduledRef" (
    "id" UUID NOT NULL,
    "parentId" UUID NOT NULL,
    "triggerAt" TIMESTAMP(3) NOT NULL,
    "tickerId" UUID,
    "input" JSONB,
    "childIndex" INTEGER,
    "childKey" TEXT,
    "parentStepRunId" UUID,
    "parentWorkflowRunId" UUID,

    CONSTRAINT "WorkflowTriggerScheduledRef_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WorkflowTriggers" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "workflowVersionId" UUID NOT NULL,
    "tenantId" UUID NOT NULL,

    CONSTRAINT "WorkflowTriggers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WorkflowVersion" (
    "id" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "version" TEXT,
    "order" BIGSERIAL NOT NULL,
    "workflowId" UUID NOT NULL,
    "checksum" TEXT NOT NULL,
    "scheduleTimeout" TEXT NOT NULL DEFAULT '5m',
    "onFailureJobId" UUID,
    "sticky" "StickyStrategy",
    "kind" "WorkflowKind" NOT NULL DEFAULT 'DAG',

    CONSTRAINT "WorkflowVersion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_ActionToWorker" (
    "B" UUID NOT NULL,
    "A" UUID NOT NULL
);

-- CreateTable
CREATE TABLE "_ServiceToWorker" (
    "A" UUID NOT NULL,
    "B" UUID NOT NULL
);

-- CreateTable
CREATE TABLE "_StepOrder" (
    "A" UUID NOT NULL,
    "B" UUID NOT NULL
);

-- CreateTable
CREATE TABLE "_StepRunOrder" (
    "A" UUID NOT NULL,
    "B" UUID NOT NULL
);

-- CreateTable
CREATE TABLE "_WorkflowToWorkflowTag" (
    "A" UUID NOT NULL,
    "B" UUID NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "APIToken_id_key" ON "APIToken"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "Action_id_key" ON "Action"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "Action_tenantId_actionId_key" ON "Action"("tenantId" ASC, "actionId" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "ControllerPartition_id_key" ON "ControllerPartition"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "Dispatcher_id_key" ON "Dispatcher"("id" ASC);

-- CreateIndex
CREATE INDEX "Event_createdAt_idx" ON "Event"("createdAt" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "Event_id_key" ON "Event"("id" ASC);

-- CreateIndex
CREATE INDEX "Event_tenantId_createdAt_idx" ON "Event"("tenantId" ASC, "createdAt" ASC);

-- CreateIndex
CREATE INDEX "Event_tenantId_idx" ON "Event"("tenantId" ASC);

-- CreateIndex
CREATE INDEX "GetGroupKeyRun_deletedAt_idx" ON "GetGroupKeyRun"("deletedAt" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "GetGroupKeyRun_id_key" ON "GetGroupKeyRun"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "GetGroupKeyRun_workflowRunId_key" ON "GetGroupKeyRun"("workflowRunId" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "Job_id_key" ON "Job"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "Job_workflowVersionId_name_key" ON "Job"("workflowVersionId" ASC, "name" ASC);

-- CreateIndex
CREATE INDEX "JobRun_deletedAt_idx" ON "JobRun"("deletedAt" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "JobRun_id_key" ON "JobRun"("id" ASC);

-- CreateIndex
CREATE INDEX "JobRun_workflowRunId_tenantId_idx" ON "JobRun"("workflowRunId" ASC, "tenantId" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "JobRunLookupData_id_key" ON "JobRunLookupData"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "JobRunLookupData_jobRunId_key" ON "JobRunLookupData"("jobRunId" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "JobRunLookupData_jobRunId_tenantId_key" ON "JobRunLookupData"("jobRunId" ASC, "tenantId" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "Queue_tenantId_name_key" ON "Queue"("tenantId" ASC, "name" ASC);

-- CreateIndex
CREATE INDEX "QueueItem_isQueued_priority_tenantId_queue_id_idx" ON "QueueItem"("isQueued" ASC, "priority" ASC, "tenantId" ASC, "queue" ASC, "id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "RateLimit_tenantId_key_key" ON "RateLimit"("tenantId" ASC, "key" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "SNSIntegration_id_key" ON "SNSIntegration"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "SNSIntegration_tenantId_topicArn_key" ON "SNSIntegration"("tenantId" ASC, "topicArn" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "SecurityCheckIdent_id_key" ON "SecurityCheckIdent"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "Service_id_key" ON "Service"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "Service_tenantId_name_key" ON "Service"("tenantId" ASC, "name" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "SlackAppWebhook_id_key" ON "SlackAppWebhook"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "SlackAppWebhook_tenantId_teamId_channelId_key" ON "SlackAppWebhook"("tenantId" ASC, "teamId" ASC, "channelId" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "Step_id_key" ON "Step"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "Step_jobId_readableId_key" ON "Step"("jobId" ASC, "readableId" ASC);

-- CreateIndex
CREATE INDEX "StepDesiredWorkerLabel_stepId_idx" ON "StepDesiredWorkerLabel"("stepId" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "StepDesiredWorkerLabel_stepId_key_key" ON "StepDesiredWorkerLabel"("stepId" ASC, "key" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "StepRateLimit_stepId_rateLimitKey_key" ON "StepRateLimit"("stepId" ASC, "rateLimitKey" ASC);

-- CreateIndex
CREATE INDEX "StepRun_createdAt_idx" ON "StepRun"("createdAt" ASC);

-- CreateIndex
CREATE INDEX "StepRun_deletedAt_idx" ON "StepRun"("deletedAt" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "StepRun_id_key" ON "StepRun"("id" ASC);

-- CreateIndex
CREATE INDEX "StepRun_id_tenantId_idx" ON "StepRun"("id" ASC, "tenantId" ASC);

-- CreateIndex
CREATE INDEX "StepRun_jobRunId_status_idx" ON "StepRun"("jobRunId" ASC, "status" ASC);

-- CreateIndex
CREATE INDEX "StepRun_jobRunId_status_tenantId_idx" ON "StepRun"("jobRunId" ASC, "status" ASC, "tenantId" ASC);

-- CreateIndex
CREATE INDEX "StepRun_jobRunId_tenantId_order_idx" ON "StepRun"("jobRunId" ASC, "tenantId" ASC, "order" ASC);

-- CreateIndex
CREATE INDEX "StepRun_stepId_idx" ON "StepRun"("stepId" ASC);

-- CreateIndex
CREATE INDEX "StepRun_tenantId_idx" ON "StepRun"("tenantId" ASC);

-- CreateIndex
CREATE INDEX "StepRun_tenantId_status_timeoutAt_idx" ON "StepRun"("tenantId" ASC, "status" ASC, "timeoutAt" ASC);

-- CreateIndex
CREATE INDEX "StepRun_workerId_idx" ON "StepRun"("workerId" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "StepRunEvent_id_key" ON "StepRunEvent"("id" ASC);

-- CreateIndex
CREATE INDEX "StepRunEvent_stepRunId_idx" ON "StepRunEvent"("stepRunId" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "StepRunResultArchive_id_key" ON "StepRunResultArchive"("id" ASC);

-- CreateIndex
CREATE INDEX "Tenant_controllerPartitionId_idx" ON "Tenant"("controllerPartitionId" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "Tenant_id_key" ON "Tenant"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "Tenant_slug_key" ON "Tenant"("slug" ASC);

-- CreateIndex
CREATE INDEX "Tenant_workerPartitionId_idx" ON "Tenant"("workerPartitionId" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "TenantAlertEmailGroup_id_key" ON "TenantAlertEmailGroup"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "TenantAlertingSettings_id_key" ON "TenantAlertingSettings"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "TenantAlertingSettings_tenantId_key" ON "TenantAlertingSettings"("tenantId" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "TenantInviteLink_id_key" ON "TenantInviteLink"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "TenantMember_id_key" ON "TenantMember"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "TenantMember_tenantId_userId_key" ON "TenantMember"("tenantId" ASC, "userId" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "TenantResourceLimit_id_key" ON "TenantResourceLimit"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "TenantResourceLimit_tenantId_resource_key" ON "TenantResourceLimit"("tenantId" ASC, "resource" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "TenantResourceLimitAlert_id_key" ON "TenantResourceLimitAlert"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "TenantVcsProvider_id_key" ON "TenantVcsProvider"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "TenantVcsProvider_tenantId_vcsProvider_key" ON "TenantVcsProvider"("tenantId" ASC, "vcsProvider" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "TenantWorkerPartition_id_key" ON "TenantWorkerPartition"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "Ticker_id_key" ON "Ticker"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "User_id_key" ON "User"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "UserOAuth_id_key" ON "UserOAuth"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "UserOAuth_userId_key" ON "UserOAuth"("userId" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "UserOAuth_userId_provider_key" ON "UserOAuth"("userId" ASC, "provider" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "UserPassword_userId_key" ON "UserPassword"("userId" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "UserSession_id_key" ON "UserSession"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WebhookWorker_id_key" ON "WebhookWorker"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WebhookWorker_url_key" ON "WebhookWorker"("url" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WebhookWorkerWorkflow_id_key" ON "WebhookWorkerWorkflow"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WebhookWorkerWorkflow_webhookWorkerId_workflowId_key" ON "WebhookWorkerWorkflow"("webhookWorkerId" ASC, "workflowId" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "Worker_id_key" ON "Worker"("id" ASC);

-- CreateIndex
CREATE INDEX "WorkerLabel_workerId_idx" ON "WorkerLabel"("workerId" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WorkerLabel_workerId_key_key" ON "WorkerLabel"("workerId" ASC, "key" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WorkerSemaphore_workerId_key" ON "WorkerSemaphore"("workerId" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WorkerSemaphoreSlot_id_key" ON "WorkerSemaphoreSlot"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WorkerSemaphoreSlot_stepRunId_key" ON "WorkerSemaphoreSlot"("stepRunId" ASC);

-- CreateIndex
CREATE INDEX "WorkerSemaphoreSlot_workerId_idx" ON "WorkerSemaphoreSlot"("workerId" ASC);

-- CreateIndex
CREATE INDEX "Workflow_deletedAt_idx" ON "Workflow"("deletedAt" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "Workflow_id_key" ON "Workflow"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "Workflow_tenantId_name_key" ON "Workflow"("tenantId" ASC, "name" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WorkflowConcurrency_id_key" ON "WorkflowConcurrency"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WorkflowConcurrency_workflowVersionId_key" ON "WorkflowConcurrency"("workflowVersionId" ASC);

-- CreateIndex
CREATE INDEX "WorkflowRun_createdAt_idx" ON "WorkflowRun"("createdAt" ASC);

-- CreateIndex
CREATE INDEX "WorkflowRun_deletedAt_idx" ON "WorkflowRun"("deletedAt" ASC);

-- CreateIndex
CREATE INDEX "WorkflowRun_finishedAt_idx" ON "WorkflowRun"("finishedAt" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WorkflowRun_id_key" ON "WorkflowRun"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WorkflowRun_parentId_parentStepRunId_childKey_key" ON "WorkflowRun"("parentId" ASC, "parentStepRunId" ASC, "childKey" ASC);

-- CreateIndex
CREATE INDEX "WorkflowRun_status_idx" ON "WorkflowRun"("status" ASC);

-- CreateIndex
CREATE INDEX "WorkflowRun_tenantId_createdAt_idx" ON "WorkflowRun"("tenantId" ASC, "createdAt" ASC);

-- CreateIndex
CREATE INDEX "WorkflowRun_tenantId_idx" ON "WorkflowRun"("tenantId" ASC);

-- CreateIndex
CREATE INDEX "WorkflowRun_workflowVersionId_idx" ON "WorkflowRun"("workflowVersionId" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WorkflowRunDedupe_id_key" ON "WorkflowRunDedupe"("id" ASC);

-- CreateIndex
CREATE INDEX "WorkflowRunDedupe_tenantId_value_idx" ON "WorkflowRunDedupe"("tenantId" ASC, "value" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WorkflowRunDedupe_tenantId_workflowId_value_key" ON "WorkflowRunDedupe"("tenantId" ASC, "workflowId" ASC, "value" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WorkflowRunStickyState_workflowRunId_key" ON "WorkflowRunStickyState"("workflowRunId" ASC);

-- CreateIndex
CREATE INDEX "WorkflowRunTriggeredBy_eventId_idx" ON "WorkflowRunTriggeredBy"("eventId" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WorkflowRunTriggeredBy_id_key" ON "WorkflowRunTriggeredBy"("id" ASC);

-- CreateIndex
CREATE INDEX "WorkflowRunTriggeredBy_parentId_idx" ON "WorkflowRunTriggeredBy"("parentId" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WorkflowRunTriggeredBy_parentId_key" ON "WorkflowRunTriggeredBy"("parentId" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WorkflowRunTriggeredBy_scheduledId_key" ON "WorkflowRunTriggeredBy"("scheduledId" ASC);

-- CreateIndex
CREATE INDEX "WorkflowRunTriggeredBy_tenantId_idx" ON "WorkflowRunTriggeredBy"("tenantId" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WorkflowTag_id_key" ON "WorkflowTag"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WorkflowTag_tenantId_name_key" ON "WorkflowTag"("tenantId" ASC, "name" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WorkflowTriggerCronRef_parentId_cron_key" ON "WorkflowTriggerCronRef"("parentId" ASC, "cron" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WorkflowTriggerEventRef_parentId_eventKey_key" ON "WorkflowTriggerEventRef"("parentId" ASC, "eventKey" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WorkflowTriggerScheduledRef_id_key" ON "WorkflowTriggerScheduledRef"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WorkflowTriggerScheduledRef_parentId_parentStepRunId_childK_key" ON "WorkflowTriggerScheduledRef"("parentId" ASC, "parentStepRunId" ASC, "childKey" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WorkflowTriggers_id_key" ON "WorkflowTriggers"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WorkflowTriggers_workflowVersionId_key" ON "WorkflowTriggers"("workflowVersionId" ASC);

-- CreateIndex
CREATE INDEX "WorkflowVersion_deletedAt_idx" ON "WorkflowVersion"("deletedAt" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WorkflowVersion_id_key" ON "WorkflowVersion"("id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "WorkflowVersion_onFailureJobId_key" ON "WorkflowVersion"("onFailureJobId" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "_ActionToWorker_AB_unique" ON "_ActionToWorker"("A" ASC, "B" ASC);

-- CreateIndex
CREATE INDEX "_ActionToWorker_B_index" ON "_ActionToWorker"("B" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "_ServiceToWorker_AB_unique" ON "_ServiceToWorker"("A" ASC, "B" ASC);

-- CreateIndex
CREATE INDEX "_ServiceToWorker_B_index" ON "_ServiceToWorker"("B" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "_StepOrder_AB_unique" ON "_StepOrder"("A" ASC, "B" ASC);

-- CreateIndex
CREATE INDEX "_StepOrder_B_index" ON "_StepOrder"("B" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "_StepRunOrder_AB_unique" ON "_StepRunOrder"("A" ASC, "B" ASC);

-- CreateIndex
CREATE INDEX "_StepRunOrder_B_index" ON "_StepRunOrder"("B" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "_WorkflowToWorkflowTag_AB_unique" ON "_WorkflowToWorkflowTag"("A" ASC, "B" ASC);

-- CreateIndex
CREATE INDEX "_WorkflowToWorkflowTag_B_index" ON "_WorkflowToWorkflowTag"("B" ASC);

-- AddForeignKey
ALTER TABLE "APIToken" ADD CONSTRAINT "APIToken_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Action" ADD CONSTRAINT "Action_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Event" ADD CONSTRAINT "Event_replayedFromId_fkey" FOREIGN KEY ("replayedFromId") REFERENCES "Event"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Event" ADD CONSTRAINT "Event_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GetGroupKeyRun" ADD CONSTRAINT "GetGroupKeyRun_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GetGroupKeyRun" ADD CONSTRAINT "GetGroupKeyRun_tickerId_fkey" FOREIGN KEY ("tickerId") REFERENCES "Ticker"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GetGroupKeyRun" ADD CONSTRAINT "GetGroupKeyRun_workerId_fkey" FOREIGN KEY ("workerId") REFERENCES "Worker"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GetGroupKeyRun" ADD CONSTRAINT "GetGroupKeyRun_workflowRunId_fkey" FOREIGN KEY ("workflowRunId") REFERENCES "WorkflowRun"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Job" ADD CONSTRAINT "Job_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Job" ADD CONSTRAINT "Job_workflowVersionId_fkey" FOREIGN KEY ("workflowVersionId") REFERENCES "WorkflowVersion"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "JobRun" ADD CONSTRAINT "JobRun_jobId_fkey" FOREIGN KEY ("jobId") REFERENCES "Job"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "JobRun" ADD CONSTRAINT "JobRun_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "JobRun" ADD CONSTRAINT "JobRun_tickerId_fkey" FOREIGN KEY ("tickerId") REFERENCES "Ticker"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "JobRun" ADD CONSTRAINT "JobRun_workflowRunId_fkey" FOREIGN KEY ("workflowRunId") REFERENCES "WorkflowRun"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "JobRunLookupData" ADD CONSTRAINT "JobRunLookupData_jobRunId_fkey" FOREIGN KEY ("jobRunId") REFERENCES "JobRun"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "JobRunLookupData" ADD CONSTRAINT "JobRunLookupData_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LogLine" ADD CONSTRAINT "LogLine_stepRunId_fkey" FOREIGN KEY ("stepRunId") REFERENCES "StepRun"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LogLine" ADD CONSTRAINT "LogLine_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RateLimit" ADD CONSTRAINT "RateLimit_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SNSIntegration" ADD CONSTRAINT "SNSIntegration_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Service" ADD CONSTRAINT "Service_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SlackAppWebhook" ADD CONSTRAINT "SlackAppWebhook_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Step" ADD CONSTRAINT "Step_actionId_tenantId_fkey" FOREIGN KEY ("actionId", "tenantId") REFERENCES "Action"("actionId", "tenantId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Step" ADD CONSTRAINT "Step_jobId_fkey" FOREIGN KEY ("jobId") REFERENCES "Job"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Step" ADD CONSTRAINT "Step_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StepDesiredWorkerLabel" ADD CONSTRAINT "StepDesiredWorkerLabel_stepId_fkey" FOREIGN KEY ("stepId") REFERENCES "Step"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StepRateLimit" ADD CONSTRAINT "StepRateLimit_stepId_fkey" FOREIGN KEY ("stepId") REFERENCES "Step"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StepRateLimit" ADD CONSTRAINT "StepRateLimit_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StepRateLimit" ADD CONSTRAINT "StepRateLimit_tenantId_rateLimitKey_fkey" FOREIGN KEY ("tenantId", "rateLimitKey") REFERENCES "RateLimit"("tenantId", "key") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StepRun" ADD CONSTRAINT "StepRun_jobRunId_fkey" FOREIGN KEY ("jobRunId") REFERENCES "JobRun"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StepRun" ADD CONSTRAINT "StepRun_stepId_fkey" FOREIGN KEY ("stepId") REFERENCES "Step"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StepRun" ADD CONSTRAINT "StepRun_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StepRun" ADD CONSTRAINT "StepRun_tickerId_fkey" FOREIGN KEY ("tickerId") REFERENCES "Ticker"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StepRun" ADD CONSTRAINT "StepRun_workerId_fkey" FOREIGN KEY ("workerId") REFERENCES "Worker"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StepRunEvent" ADD CONSTRAINT "StepRunEvent_stepRunId_fkey" FOREIGN KEY ("stepRunId") REFERENCES "StepRun"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StepRunResultArchive" ADD CONSTRAINT "StepRunResultArchive_stepRunId_fkey" FOREIGN KEY ("stepRunId") REFERENCES "StepRun"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StreamEvent" ADD CONSTRAINT "StreamEvent_stepRunId_fkey" FOREIGN KEY ("stepRunId") REFERENCES "StepRun"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StreamEvent" ADD CONSTRAINT "StreamEvent_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Tenant" ADD CONSTRAINT "Tenant_controllerPartitionId_fkey" FOREIGN KEY ("controllerPartitionId") REFERENCES "ControllerPartition"("id") ON DELETE SET NULL ON UPDATE SET NULL;

-- AddForeignKey
ALTER TABLE "Tenant" ADD CONSTRAINT "Tenant_workerPartitionId_fkey" FOREIGN KEY ("workerPartitionId") REFERENCES "TenantWorkerPartition"("id") ON DELETE SET NULL ON UPDATE SET NULL;

-- AddForeignKey
ALTER TABLE "TenantAlertEmailGroup" ADD CONSTRAINT "TenantAlertEmailGroup_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TenantAlertingSettings" ADD CONSTRAINT "TenantAlertingSettings_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TenantAlertingSettings" ADD CONSTRAINT "TenantAlertingSettings_tickerId_fkey" FOREIGN KEY ("tickerId") REFERENCES "Ticker"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TenantInviteLink" ADD CONSTRAINT "TenantInviteLink_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TenantMember" ADD CONSTRAINT "TenantMember_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TenantMember" ADD CONSTRAINT "TenantMember_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TenantResourceLimit" ADD CONSTRAINT "TenantResourceLimit_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TenantResourceLimitAlert" ADD CONSTRAINT "TenantResourceLimitAlert_resourceLimitId_fkey" FOREIGN KEY ("resourceLimitId") REFERENCES "TenantResourceLimit"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TenantResourceLimitAlert" ADD CONSTRAINT "TenantResourceLimitAlert_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TenantVcsProvider" ADD CONSTRAINT "TenantVcsProvider_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserOAuth" ADD CONSTRAINT "UserOAuth_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserPassword" ADD CONSTRAINT "UserPassword_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserSession" ADD CONSTRAINT "UserSession_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WebhookWorker" ADD CONSTRAINT "WebhookWorker_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WebhookWorker" ADD CONSTRAINT "WebhookWorker_tokenId_fkey" FOREIGN KEY ("tokenId") REFERENCES "APIToken"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WebhookWorkerWorkflow" ADD CONSTRAINT "WebhookWorkerWorkflow_webhookWorkerId_fkey" FOREIGN KEY ("webhookWorkerId") REFERENCES "WebhookWorker"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WebhookWorkerWorkflow" ADD CONSTRAINT "WebhookWorkerWorkflow_workflowId_fkey" FOREIGN KEY ("workflowId") REFERENCES "Workflow"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Worker" ADD CONSTRAINT "Worker_dispatcherId_fkey" FOREIGN KEY ("dispatcherId") REFERENCES "Dispatcher"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Worker" ADD CONSTRAINT "Worker_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkerLabel" ADD CONSTRAINT "WorkerLabel_workerId_fkey" FOREIGN KEY ("workerId") REFERENCES "Worker"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkerSemaphore" ADD CONSTRAINT "WorkerSemaphore_workerId_fkey" FOREIGN KEY ("workerId") REFERENCES "Worker"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkerSemaphoreSlot" ADD CONSTRAINT "WorkerSemaphoreSlot_stepRunId_fkey" FOREIGN KEY ("stepRunId") REFERENCES "StepRun"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkerSemaphoreSlot" ADD CONSTRAINT "WorkerSemaphoreSlot_workerId_fkey" FOREIGN KEY ("workerId") REFERENCES "Worker"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Workflow" ADD CONSTRAINT "Workflow_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowConcurrency" ADD CONSTRAINT "WorkflowConcurrency_getConcurrencyGroupId_fkey" FOREIGN KEY ("getConcurrencyGroupId") REFERENCES "Action"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowConcurrency" ADD CONSTRAINT "WorkflowConcurrency_workflowVersionId_fkey" FOREIGN KEY ("workflowVersionId") REFERENCES "WorkflowVersion"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowRun" ADD CONSTRAINT "WorkflowRun_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "WorkflowRun"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowRun" ADD CONSTRAINT "WorkflowRun_parentStepRunId_fkey" FOREIGN KEY ("parentStepRunId") REFERENCES "StepRun"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowRun" ADD CONSTRAINT "WorkflowRun_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowRun" ADD CONSTRAINT "WorkflowRun_workflowVersionId_fkey" FOREIGN KEY ("workflowVersionId") REFERENCES "WorkflowVersion"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowRunDedupe" ADD CONSTRAINT "WorkflowRunDedupe_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowRunStickyState" ADD CONSTRAINT "WorkflowRunStickyState_workflowRunId_fkey" FOREIGN KEY ("workflowRunId") REFERENCES "WorkflowRun"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowRunTriggeredBy" ADD CONSTRAINT "WorkflowRunTriggeredBy_cronParentId_cronSchedule_fkey" FOREIGN KEY ("cronParentId", "cronSchedule") REFERENCES "WorkflowTriggerCronRef"("parentId", "cron") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowRunTriggeredBy" ADD CONSTRAINT "WorkflowRunTriggeredBy_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES "Event"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowRunTriggeredBy" ADD CONSTRAINT "WorkflowRunTriggeredBy_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "WorkflowRun"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowRunTriggeredBy" ADD CONSTRAINT "WorkflowRunTriggeredBy_scheduledId_fkey" FOREIGN KEY ("scheduledId") REFERENCES "WorkflowTriggerScheduledRef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowRunTriggeredBy" ADD CONSTRAINT "WorkflowRunTriggeredBy_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowTag" ADD CONSTRAINT "WorkflowTag_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowTriggerCronRef" ADD CONSTRAINT "WorkflowTriggerCronRef_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "WorkflowTriggers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowTriggerCronRef" ADD CONSTRAINT "WorkflowTriggerCronRef_tickerId_fkey" FOREIGN KEY ("tickerId") REFERENCES "Ticker"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowTriggerEventRef" ADD CONSTRAINT "WorkflowTriggerEventRef_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "WorkflowTriggers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowTriggerScheduledRef" ADD CONSTRAINT "WorkflowTriggerScheduledRef_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "WorkflowVersion"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowTriggerScheduledRef" ADD CONSTRAINT "WorkflowTriggerScheduledRef_parentStepRunId_fkey" FOREIGN KEY ("parentStepRunId") REFERENCES "StepRun"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowTriggerScheduledRef" ADD CONSTRAINT "WorkflowTriggerScheduledRef_parentWorkflowRunId_fkey" FOREIGN KEY ("parentWorkflowRunId") REFERENCES "WorkflowRun"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowTriggerScheduledRef" ADD CONSTRAINT "WorkflowTriggerScheduledRef_tickerId_fkey" FOREIGN KEY ("tickerId") REFERENCES "Ticker"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowTriggers" ADD CONSTRAINT "WorkflowTriggers_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowTriggers" ADD CONSTRAINT "WorkflowTriggers_workflowVersionId_fkey" FOREIGN KEY ("workflowVersionId") REFERENCES "WorkflowVersion"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowVersion" ADD CONSTRAINT "WorkflowVersion_onFailureJobId_fkey" FOREIGN KEY ("onFailureJobId") REFERENCES "Job"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowVersion" ADD CONSTRAINT "WorkflowVersion_workflowId_fkey" FOREIGN KEY ("workflowId") REFERENCES "Workflow"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ActionToWorker" ADD CONSTRAINT "_ActionToWorker_A_fkey" FOREIGN KEY ("A") REFERENCES "Action"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ActionToWorker" ADD CONSTRAINT "_ActionToWorker_B_fkey" FOREIGN KEY ("B") REFERENCES "Worker"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ServiceToWorker" ADD CONSTRAINT "_ServiceToWorker_A_fkey" FOREIGN KEY ("A") REFERENCES "Service"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ServiceToWorker" ADD CONSTRAINT "_ServiceToWorker_B_fkey" FOREIGN KEY ("B") REFERENCES "Worker"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_StepOrder" ADD CONSTRAINT "_StepOrder_A_fkey" FOREIGN KEY ("A") REFERENCES "Step"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_StepOrder" ADD CONSTRAINT "_StepOrder_B_fkey" FOREIGN KEY ("B") REFERENCES "Step"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_StepRunOrder" ADD CONSTRAINT "_StepRunOrder_A_fkey" FOREIGN KEY ("A") REFERENCES "StepRun"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_StepRunOrder" ADD CONSTRAINT "_StepRunOrder_B_fkey" FOREIGN KEY ("B") REFERENCES "StepRun"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_WorkflowToWorkflowTag" ADD CONSTRAINT "_WorkflowToWorkflowTag_A_fkey" FOREIGN KEY ("A") REFERENCES "Workflow"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_WorkflowToWorkflowTag" ADD CONSTRAINT "_WorkflowToWorkflowTag_B_fkey" FOREIGN KEY ("B") REFERENCES "WorkflowTag"("id") ON DELETE CASCADE ON UPDATE CASCADE;
