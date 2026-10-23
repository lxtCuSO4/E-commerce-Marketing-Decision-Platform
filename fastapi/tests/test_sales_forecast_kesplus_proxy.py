import unittest
from pathlib import Path


class SalesForecastKesplusProxyTestCase(unittest.TestCase):
    def test_kesplus_sales_forecast_proxy_targets_platform_hosted_route(self):
        source = (
            Path(__file__).resolve().parents[2]
            / ".kesplus"
            / "sql"
            / "销售预测"
            / "函数"
            / "predictSalesForecastOnline(item_id integer,anchor_date date,horizon_days integer,feature_data json).kfun"
        )
        text = source.read_text(encoding="utf-8")

        self.assertIn("http://fastapi:54903/api/EMDMP/sales-forecast/predict", text)
        self.assertNotIn("http://fastapi:54903/api/EMDMPAI/sales-forecast/predict", text)


if __name__ == "__main__":
    unittest.main()
