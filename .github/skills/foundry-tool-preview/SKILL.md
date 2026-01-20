---
name: foundry-tool-preview
description: Guide for previewing and testing new tools in Azure Foundry agents before deployment. Use this when asked to preview, test, or validate new tools or MCP servers in Foundry.
license: MIT
---

# Foundry Tool Preview Guide

This skill provides step-by-step instructions for previewing and testing new tools in Azure Foundry agents before full deployment.

## When to Use This Skill

Use this skill when:
- Testing new MCP server integrations in Foundry
- Previewing custom tools before adding them to production agents
- Validating tool configurations and permissions
- Debugging tool connectivity issues
- Verifying tool responses and behavior

## Prerequisites

Before previewing tools:
1. **Foundry portal access** with agent configuration permissions
2. **Azure AI User Role** or higher (for OAuth tools)
3. **Tool configuration details** ready:
   - Tool name and description
   - Endpoint URL (for MCP servers)
   - Authentication details (if required)
   - Required permissions/scopes

## Preview Process

### Step 1: Create a Test Agent

For safe testing, create a dedicated test agent:

1. Open Foundry portal
2. Click "Create new agent" or duplicate an existing agent
3. Name it clearly (e.g., "Test Agent - Tool Preview")
4. Configure basic settings (model, system message)
5. **Do not connect production tools yet**

### Step 2: Add the Tool to Test Agent

#### For MCP Servers:
1. In your test agent, click "Connect a tool"
2. Select "Custom" > "MCP"
3. Fill in configuration:
   - **Name**: Descriptive name for the tool
   - **MCP server endpoint**: The server URL
   - **Authentication**: Select appropriate type
     - None (for public tools)
     - API Key (for key-based auth)
     - OAuth Identity Passthrough (for user-scoped access)
4. Fill in authentication details if required
5. Click "Save" or "Connect"

#### For Built-in Tools:
1. In your test agent, click "Connect a tool"
2. Browse available built-in tools
3. Select the tool you want to preview
4. Configure any required settings
5. Click "Connect"

### Step 3: Grant Necessary Permissions

For OAuth tools:
1. After connecting, you'll see a consent link in the chat
2. Click the link and authenticate
3. Grant the requested permissions
4. Return to the agent chat

For API key tools:
- Verify the API key has necessary scopes
- Check rate limits and quotas

### Step 4: Test Tool Functionality

Run comprehensive tests:

#### Basic Functionality Test
```
Test query: "Can you [basic operation] using [tool name]?"
Example: "Can you list my recent files using SharePoint?"
```

#### Error Handling Test
```
Test query: "Try to [invalid operation] using [tool name]"
Example: "Try to access a file that doesn't exist"
```

#### Permission Scope Test
```
Test query: "Can you [operation requiring specific permission]?"
Example: "Can you write to this SharePoint site?"
```

#### Performance Test
```
Test query: "[operation that returns large dataset]"
Example: "List all files in my entire OneDrive"
```

### Step 5: Review Tool Behavior

Check the following:

✅ **Successful Responses:**
- Tool returns expected data
- Response format is correct
- Data is relevant and accurate

✅ **Error Messages:**
- Clear error messages for failures
- Appropriate error codes
- Helpful troubleshooting hints

✅ **Performance:**
- Response times are acceptable
- Timeouts are handled gracefully
- Large responses don't crash the agent

✅ **Security:**
- Only authorized data is accessible
- Permissions are properly scoped
- No sensitive data leakage

### Step 6: Document Findings

Create a test report with:

```markdown
# Tool Preview Report: [Tool Name]

## Date: [Date]
## Tester: [Your Name]

### Tool Configuration
- Name: [Tool name]
- Type: [MCP/Built-in]
- Authentication: [Auth type]
- Endpoint: [URL if applicable]

### Test Results

#### ✅ Successful Tests
- [Test case 1]: [Result]
- [Test case 2]: [Result]

#### ❌ Failed Tests
- [Test case 1]: [Error message and details]

#### 🔍 Observations
- [Any notable behavior]
- [Performance notes]
- [Security considerations]

### Recommendations
- [ ] Ready for production
- [ ] Needs configuration changes
- [ ] Requires additional testing
- [ ] Not recommended (explain why)

### Next Steps
- [Action items]
```

### Step 7: Deploy to Production (if approved)

Once testing is complete and successful:

1. Review test report with stakeholders
2. Get approval for production deployment
3. Add tool to production agent(s)
4. Monitor initial production usage
5. Gather user feedback

## Troubleshooting Common Issues

| Issue | Possible Cause | Solution |
|-------|----------------|----------|
| Tool not appearing in agent | Connection failed | Verify endpoint URL and network connectivity |
| Authentication errors | Invalid credentials | Check API keys, OAuth config, and permissions |
| Permission denied | Insufficient scope | Review granted permissions in Azure Portal |
| Timeout errors | Slow endpoint | Check server performance and network latency |
| Invalid response format | API version mismatch | Verify MCP server version compatibility |
| Consent link not working | Redirect URL mismatch | Ensure redirect URL matches in Entra app |

## Best Practices

### Testing Best Practices
- ✅ Test with multiple user accounts (different permission levels)
- ✅ Test edge cases and error conditions
- ✅ Document all test cases and results
- ✅ Use a dedicated test agent (don't test in production)
- ✅ Test with realistic data volumes

### Security Best Practices
- ✅ Never use production credentials in test environments
- ✅ Review all permissions before granting consent
- ✅ Test with minimum required permissions first
- ✅ Verify data isolation between users
- ✅ Check for proper error message sanitization

### Deployment Best Practices
- ✅ Gradual rollout (start with small user group)
- ✅ Monitor error rates after deployment
- ✅ Have rollback plan ready
- ✅ Communicate changes to users
- ✅ Provide user documentation

## Monitoring After Deployment

Track these metrics:
- Tool usage frequency
- Success/error rates
- Average response time
- User feedback and issues
- Permission consent rates

## Example Test Scenarios

### Scenario 1: Testing SharePoint MCP Server
```
1. "List files in my Documents folder"
2. "Search for files containing 'Q4 Report'"
3. "Show me recently modified files"
4. "Try to access a file I don't have permissions for"
5. "Download a large file (>10MB)"
```

### Scenario 2: Testing Email Integration
```
1. "Show my recent emails"
2. "Find emails from [person]"
3. "Send a test email to myself"
4. "Try to send email to invalid address"
5. "Search for emails with attachments"
```

### Scenario 3: Testing Calendar Integration
```
1. "Show my meetings today"
2. "Create a test meeting for tomorrow"
3. "Find available time slots this week"
4. "Delete the test meeting"
5. "Show meetings in a different timezone"
```

## Rollback Procedure

If issues are found after deployment:

1. **Immediate**: Disconnect tool from affected agents
2. **Notify**: Alert users of the issue and downtime
3. **Investigate**: Review logs and error reports
4. **Fix**: Address identified issues
5. **Re-test**: Run preview process again
6. **Re-deploy**: Add tool back once fixed

## References

- [Foundry Agent Configuration Documentation](https://learn.microsoft.com/azure/ai-foundry/)
- [MCP Server Protocol Specification](https://modelcontextprotocol.io/)
- Tool-specific documentation and API references
