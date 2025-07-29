//
//  SupabaseManager.swift
//  MoneyPlan
//
//  Created by Paula Arroyo on 26/7/25.
//

import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()

    let client: SupabaseClient

    private init() {
        self.client = SupabaseClient(
            supabaseURL: URL(string: "https://dreiuditdgvqavqqserj.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRyZWl1ZGl0ZGd2cWF2cXFzZXJqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM1NDM5NDIsImV4cCI6MjA2OTExOTk0Mn0.DwGpGyaquGs8nw01uB_GPaKHYbD4ybTm_lcTfrXjEYA"
        )
    }
}
