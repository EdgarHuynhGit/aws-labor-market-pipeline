# Architecture

```
EventBridge (schedule)
      |
      v
   Lambda  ---->  S3 (raw/)
                      |
                      v
              Glue Crawler + Glue Job
                      |
                      v
              S3 (processed/, Parquet)
                      |
                      v
                   Athena  ---->  QuickSight / Flask+React dashboard
```

Replace this with a proper diagram (draw.io, Excalidraw, or the AWS
architecture icon set) once the pipeline is built end-to-end — screenshot
it into `architecture.png` and link it from the root README.
