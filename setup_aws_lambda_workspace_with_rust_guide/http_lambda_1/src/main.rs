use lambda_http::{
    http::{Response, StatusCode},
    run, service_fn, Error, IntoResponse, Request, RequestPayloadExt,
};
use serde::{Deserialize, Serialize};
use serde_json::json;
use std::sync::Arc;
use tracing::info;

#[tokio::main]
async fn main() -> Result<(), Error> {
    // Initialize tracing for structured logging.
    common::init_tracing();

    // AppState is wrapped in an Arc for thread-safe reference counting.
    let state = Arc::new(AppState {});

    // `run` starts the Lambda runtime listener.
    // `service_fn` maps incoming requests to the handle_request function.
    run(service_fn(|event: Request| async {
        handle_request(&state, event).await
    }))
    .await
}

// The handler function for incoming Lambda requests.
pub async fn handle_request(_: &Arc<AppState>, event: Request) -> Result<impl IntoResponse, Error> {
    info!("Received request: {:?}", event);

    // Parse the JSON payload from the request body.
    let body = event.payload::<MyPayload>()?;

    // Construct an HTTP response.
    let response = Response::builder()
        .status(StatusCode::OK)
        .header("Content-Type", "application/json")
        .body(
            json!({
                "message": "Hello World",
                "payload": body,
            })
            .to_string(),
        )
        .map_err(Box::new)?;

    // Return the response.
    Ok(response)
}

// AppState can hold shared state or dependencies (like database connections).
pub struct AppState {}

// Define a structure for the expected payload in the HTTP request.
#[derive(Deserialize, Serialize, Debug, Clone)]
pub struct MyPayload {
    pub prop1: String,
    pub prop2: String,
}
