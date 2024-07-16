package com.example;

import org.junit.Test;
import static org.junit.Assert.assertEquals;

public class YourClassTest {

    @Test
    public void testGreet() {
        YourClass yourClass = new YourClass();
        String result = yourClass.greet("World");
        assertEquals("Hello, World!", result);
    }
}

