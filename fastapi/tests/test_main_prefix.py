import unittest


class TestMainPrefix(unittest.TestCase):
    def test_main_registers_ai_routes_and_only_sales_forecast_alias(self):
        from main import app

        paths = {getattr(route, "path", "") for route in app.routes}
        self.assertIn("/api/EMDMPAI/product-qa/chat", paths)
        self.assertIn("/api/EMDMPAI/sales-forecast/predict", paths)
        self.assertEqual(
            {path for path in paths if path.startswith("/api/EMDMP/")},
            {"/api/EMDMP/sales-forecast/predict"},
        )


if __name__ == "__main__":
    unittest.main()
