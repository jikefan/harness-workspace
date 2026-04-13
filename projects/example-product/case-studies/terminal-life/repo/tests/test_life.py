import unittest

from life import neighbors, render, seeded_board, step


class LifeRulesTest(unittest.TestCase):
    def test_block_is_still_life(self):
        board = {(1, 1), (2, 1), (1, 2), (2, 2)}
        self.assertEqual(step(board, 5, 5, wrap=False), board)

    def test_blinker_oscillates(self):
        vertical = {(2, 1), (2, 2), (2, 3)}
        horizontal = {(1, 2), (2, 2), (3, 2)}
        self.assertEqual(step(vertical, 5, 5, wrap=False), horizontal)
        self.assertEqual(step(horizontal, 5, 5, wrap=False), vertical)

    def test_underpopulation_kills_lonely_cell(self):
        self.assertEqual(step({(2, 2)}, 5, 5, wrap=False), set())

    def test_reproduction_creates_cell_with_three_neighbors(self):
        board = {(1, 2), (2, 1), (2, 2)}
        self.assertIn((1, 1), step(board, 5, 5, wrap=False))

    def test_wrapped_neighbors_cross_edges(self):
        self.assertIn((4, 4), set(neighbors((0, 0), 5, 5, wrap=True)))
        self.assertNotIn((4, 4), set(neighbors((0, 0), 5, 5, wrap=False)))

    def test_named_seed_is_centered_on_board(self):
        board = seeded_board("glider", 10, 10, 0.25)
        self.assertEqual(len(board), 5)
        self.assertTrue(all(0 <= x < 10 and 0 <= y < 10 for x, y in board))

    def test_render_contains_generation_and_border(self):
        output = render({(0, 0)}, 3, 2, 7)
        self.assertIn("Generation 7", output)
        self.assertIn("+---+", output)
        self.assertIn("█", output)


if __name__ == "__main__":
    unittest.main()
