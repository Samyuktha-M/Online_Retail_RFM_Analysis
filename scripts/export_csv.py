from db import run_query

tables = ['rfm_scores','rfm_segments', 'sales_clean']
for t in tables:
    df = run_query(f'SELECT * FROM {t}')
    df.to_csv(f'/Users/samyukthamuralidharan/Desktop/{t}.csv', index=False)
    print(f'{t}.csv saved — {len(df)} rows')
