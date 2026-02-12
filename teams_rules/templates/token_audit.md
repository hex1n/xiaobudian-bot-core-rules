# Token Audit

说明
1. actual 从日志或 provider usage 字段获得
2. estimate 无法获得真实 token 时使用估算

估算方法建议
1. estimate_input_tokens = ceil(len(input_chars) / 4)
2. estimate_output_tokens = ceil(len(output_chars) / 4)

## Model Chain

dispatcher_model:
specialists_models:

## Per Step Usage

| step | session_label | role | model | tokens_in | tokens_out | tokens_total | type | notes |
|------|---------------|------|-------|-----------|------------|--------------|------|-------|
| 1 | | | | | | | actual_or_estimate | |

## Paid Model Justification

若使用付费模型 逐条写明不可替代理由 并对应到具体 step。
