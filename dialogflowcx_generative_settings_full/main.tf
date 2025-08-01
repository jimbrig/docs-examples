resource "google_dialogflow_cx_agent" "agent" {
  display_name               = "dialogflowcx-agent-${local.name_suffix}"
  location                   = "global"
  default_language_code      = "en"
  time_zone                  = "America/New_York"
  description                = "Example description."
}

resource "google_dialogflow_cx_generative_settings" "full_generative_settings" {
  parent       = google_dialogflow_cx_agent.agent.id

  fallback_settings {
    selected_prompt = "example prompt"
    prompt_templates {
      display_name = "example prompt"
      prompt_text = "example prompt text"
      frozen = false
    }
  }

  generative_safety_settings {
    default_banned_phrase_match_strategy = "PARTIAL_MATCH"
    banned_phrases {
      text = "example text"
      language_code = "en"
    }
  }

  knowledge_connector_settings {
    business = "example business"
    agent = "example agent"
    agent_identity = "virtual agent"
    business_description = "a family company selling freshly roasted coffee beans"
    agent_scope = "Example company website"
    disable_data_store_fallback = false
  }

  language_code = "en"

  llm_model_settings {
    model = "gemini-2.0-flash-001"
    prompt_text = "example prompt text"
  }
}
