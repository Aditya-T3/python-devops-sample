import pytest
from app.calculator import add, subtract, multiply, divide

def test_add():
    """Test addition of two numbers."""
    assert add(2, 3) == 5
    assert add(-1, 1) == 0
    assert add(0, 0) == 0

def test_subtract():
    """Test subtraction of two numbers."""
    assert subtract(5, 3) == 2
    assert subtract(0, 0) == 0
    assert subtract(-1, -1) == 0

def test_multiply():
    """Test multiplication of two numbers."""
    assert multiply(2, 3) == 6
    assert multiply(-1, 3) == -3
    assert multiply(0, 10) == 0

def test_divide():
    """Test division of two numbers."""
    assert divide(10, 2) == 5
    assert divide(-6, 3) == -2

def test_divide_by_zero():
    """Ensure divide raises an error when dividing by zero."""
    with pytest.raises(ZeroDivisionError):
        divide(10, 0)
