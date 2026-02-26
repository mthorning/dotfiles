---
name: grafana
description: Query logs, metrics, or traces in Grafana using the grafana-assistant CLI. Use when the user asks to check logs, metrics, traces, alerts, or debug production issues in Grafana.
---

# Grafana Assistant

Query logs, metrics, traces, and alerts in Grafana for production debugging using `grafana-assistant prompt`.

## Workflow

1. If the user hasn't specified an instance, ask which instance to use:
   - Run `grafana-assistant config list` to show available instances
   - Default to `ops` unless the user specifies otherwise
   - Use AskUserQuestion if ambiguous

2. Formulate a clear prompt based on the user's debugging question:
 - The tool connects to an LLM with knowledge of Grafana so asking general questions instead of only loki or prometheus queries may return better results.
   - Include service/component name if mentioned
   - Include time range if mentioned (default to "last hour" if not specified)
   - Include error messages, trace IDs, or other context the user provided

3. Run the query:
   ```bash
   grafana-assistant prompt "<your prompt>" --instance <instance>
   ```

4. Present the response clearly. If the user wants to follow up, use `--continue` to maintain conversation context:
   ```bash
   grafana-assistant prompt "<follow-up prompt>" --instance <instance> --continue
   ```

## Common Query Patterns

### Logs
```bash
grafana-assistant prompt "Show me error logs for the <service> service in the last hour" --instance ops
grafana-assistant prompt "Find logs containing '<error message>' for <service> in the last 30 minutes" --instance ops
```

### Metrics
```bash
grafana-assistant prompt "What is the error rate for the <service> service over the last hour?" --instance ops
grafana-assistant prompt "Show me CPU and memory usage for <service> pods in the last 2 hours" --instance ops
```

### Traces
```bash
grafana-assistant prompt "Find traces for trace ID <id>" --instance ops
grafana-assistant prompt "Show me slow traces (>500ms) for the <service> service in the last hour" --instance ops
```

### Alerts
```bash
grafana-assistant prompt "What alerts are currently firing?" --instance ops
grafana-assistant prompt "Show me alerts that fired in the last 24 hours for <service>" --instance ops
```

## Options

| Flag          | Description                          |
| ------------- | ------------------------------------ |
| `--instance`  | Named instance from config (e.g. `ops`) |
| `--continue`  | Continue the most recent conversation |
| `--context`   | Resume a specific context ID          |
| `--timeout`   | Timeout in seconds (default: 300)     |
| `--json`      | Machine-readable JSON output          |

## Notes

- The `ops` instance is the default for production debugging
- Run `grafana-assistant config list` to see all configured instances and their auth status
- If the instance shows "Not authenticated", run `grafana-assistant auth --instance <name>`
- For long-running queries (e.g. large time ranges), increase timeout: `--timeout 600`
